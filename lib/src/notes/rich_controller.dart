import 'package:flutter/material.dart';

import 'styled_text.dart';

/// One step back in time: the text with its marks and where the caret was.
class _Step {
  _Step(this.text, this.selection, this.at, {this.typing = false});

  final StyledText text;
  final TextSelection selection;
  final DateTime at;
  final bool typing;
}

/// The text of a note: what the field shows, with the marks of each
/// character, the lists that go on by themselves and an undo that brings the
/// marks back too.
class RichTextController extends TextEditingController {
  RichTextController({StyledText? text, DateTime Function()? clock})
    : _styled = text ?? StyledText.empty,
      _clock = clock ?? DateTime.now,
      super(text: text?.text) {
    _undo.add(_Step(_styled, selection, _clock()));
  }

  /// Typing within this time of the last change is undone together.
  static const typingPause = Duration(milliseconds: 900);
  static const _historyLimit = 200;

  final DateTime Function() _clock;
  StyledText _styled;

  /// The marks for what is typed next at a caret, after a mark was turned on
  /// or off with nothing selected.
  int? _pending;

  final List<_Step> _undo = [];
  final List<_Step> _redo = [];

  StyledText get styled => _styled;

  bool get canUndo => _undo.length > 1;
  bool get canRedo => _redo.isNotEmpty;

  @override
  set value(TextEditingValue newValue) {
    final old = super.value;
    if (newValue.text == old.text) {
      if (newValue.selection != old.selection) _pending = null;
      super.value = newValue;
      return;
    }
    final adjusted = _continueList(old, newValue);
    _styled = _styled.edit(adjusted.text, typing: _pending);
    super.value = adjusted;
    _remember(typing: true);
  }

  /// Enter on a line of a list starts the next one with a bullet, and Enter
  /// on an empty one ends the list.
  TextEditingValue _continueList(TextEditingValue old, TextEditingValue next) {
    final caret = next.selection;
    if (!caret.isCollapsed ||
        next.text.length != old.text.length + 1 ||
        caret.baseOffset < 1 ||
        next.text.codeUnitAt(caret.baseOffset - 1) != 0x0A) {
      return next;
    }
    final at = caret.baseOffset - 1;
    if (next.text.replaceRange(at, at + 1, '') != old.text) return next;
    final lineStart = _styled.lineStart(at);
    if (!_styled.isBulleted(lineStart)) return next;
    final lineEnd = old.text.indexOf('\n', at);
    final line = old.text.substring(lineStart, lineEnd < 0 ? old.text.length : lineEnd);
    if (line == bullet) {
      // An empty item: the bullet goes, and the line stays.
      return TextEditingValue(
        text: old.text.replaceRange(lineStart, lineStart + bullet.length, ''),
        selection: TextSelection.collapsed(offset: lineStart),
      );
    }
    return TextEditingValue(
      text: next.text.replaceRange(at + 1, at + 1, bullet),
      selection: TextSelection.collapsed(offset: at + 1 + bullet.length),
    );
  }

  void _remember({bool typing = false}) {
    final now = _clock();
    final last = _undo.last;
    if (typing &&
        last.typing &&
        _undo.length > 1 &&
        now.difference(last.at) < typingPause) {
      _undo.removeLast();
    }
    _undo.add(_Step(_styled, selection, now, typing: typing));
    if (_undo.length > _historyLimit) _undo.removeAt(0);
    _redo.clear();
  }

  void _show(StyledText text, TextSelection selection) {
    _styled = text;
    _pending = null;
    super.value = TextEditingValue(text: text.text, selection: selection);
  }

  void undo() {
    if (!canUndo) return;
    _redo.add(_undo.removeLast());
    final step = _undo.last;
    _show(step.text, _clamp(step.selection, step.text));
  }

  void redo() {
    if (!canRedo) return;
    final step = _redo.removeLast();
    _undo.add(step);
    _show(step.text, _clamp(step.selection, step.text));
  }

  static TextSelection _clamp(TextSelection selection, StyledText text) =>
      selection.isValid
      ? TextSelection(
          baseOffset: selection.baseOffset.clamp(0, text.length),
          extentOffset: selection.extentOffset.clamp(0, text.length),
        )
      : TextSelection.collapsed(offset: text.length);

  /// The marks at the caret or over the whole selection.
  bool isActive(int mark) {
    final range = selection;
    if (!range.isValid) return false;
    if (range.isCollapsed) {
      final marks = _pending ?? _markBefore(range.start);
      return marks & mark != 0;
    }
    return _styled.hasMark(range.start, range.end, mark);
  }

  int _markBefore(int offset) =>
      offset > 0 && offset <= _styled.length ? _styled.marks[offset - 1] : 0;

  /// Turns a mark on or off for the selection, or for what comes next.
  void toggle(int mark) {
    final range = selection;
    if (!range.isValid) return;
    if (range.isCollapsed) {
      _pending = (_pending ?? _markBefore(range.start)) ^ mark;
      notifyListeners();
      return;
    }
    _styled = _styled.toggle(range.start, range.end, mark);
    _remember();
    notifyListeners();
  }

  /// Turns the lines of the selection into a list, or back.
  void toggleBullets() {
    final range = selection.isValid
        ? selection
        : TextSelection.collapsed(offset: _styled.length);
    final (text, move) = _styled.toggleBullets(range.start, range.end);
    final base = range.baseOffset;
    final extent = range.extentOffset;
    _show(
      text,
      TextSelection(baseOffset: move(base), extentOffset: move(extent)),
    );
    _remember();
  }

  /// Replaces everything, as when a note is opened. It cannot be undone.
  void load(StyledText text) {
    _undo
      ..clear()
      ..add(_Step(text, TextSelection.collapsed(offset: text.length), _clock()));
    _redo.clear();
    _show(text, TextSelection.collapsed(offset: text.length));
  }

  static TextStyle styleOf(int marks) => TextStyle(
    fontWeight: marks & Mark.bold != 0 ? FontWeight.w700 : null,
    // The handwriting is one variable font, so the weight goes to its axis.
    fontVariations: marks & Mark.bold != 0
        ? const [FontVariation('wght', 700)]
        : null,
    fontStyle: marks & Mark.italic != 0 ? FontStyle.italic : null,
    decoration: TextDecoration.combine([
      if (marks & Mark.underline != 0) TextDecoration.underline,
      if (marks & Mark.strike != 0) TextDecoration.lineThrough,
    ]),
  );

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (_styled.text != text) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }
    return TextSpan(
      style: style,
      children: [
        for (final (part, marks) in _styled.spans())
          TextSpan(text: part, style: marks == 0 ? null : styleOf(marks)),
      ],
    );
  }
}
