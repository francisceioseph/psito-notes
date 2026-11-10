import 'package:flutter/foundation.dart';

/// The marks a character can carry, as bits, so that they combine.
abstract final class Mark {
  static const bold = 1;
  static const italic = 2;
  static const underline = 4;
  static const strike = 8;

  static const all = [bold, italic, underline, strike];
}

/// The bullet that starts a line of a list.
const bullet = '• ';

/// Text with the marks of each character. It never changes: an edit gives a
/// new one.
@immutable
class StyledText {
  StyledText(this.text, [List<int>? marks])
    : marks = List.unmodifiable(marks ?? List.filled(text.length, 0)),
      assert(marks == null || marks.length == text.length);

  static final empty = StyledText('');

  /// Reads the runs saved by [toRuns]. Runs that do not fit are dropped, so
  /// that a damaged note still opens.
  factory StyledText.fromRuns(String text, List<List<int>> runs) {
    final marks = List.filled(text.length, 0);
    for (final run in runs) {
      if (run.length != 3) continue;
      final [start, end, mark] = run;
      for (var i = start.clamp(0, text.length); i < end.clamp(0, text.length); i++) {
        marks[i] = mark;
      }
    }
    return StyledText(text, marks);
  }

  final String text;
  final List<int> marks;

  int get length => text.length;

  /// The marks as [start, end, marks] runs, leaving out the plain ones.
  List<List<int>> toRuns() {
    final runs = <List<int>>[];
    var start = 0;
    for (var i = 1; i <= marks.length; i++) {
      if (i < marks.length && marks[i] == marks[start]) continue;
      if (marks[start] != 0) runs.add([start, i, marks[start]]);
      start = i;
    }
    return runs;
  }

  /// The runs of characters that share the same marks, for drawing.
  Iterable<(String, int)> spans() sync* {
    var start = 0;
    for (var i = 1; i <= length; i++) {
      if (i < length && marks[i] == marks[start]) continue;
      if (start < i) yield (text.substring(start, i), marks[start]);
      start = i;
    }
  }

  /// The text after [newText] replaced it, keeping the marks of what stayed.
  /// What was typed takes [typing], or the marks of the character before it.
  StyledText edit(String newText, {int? typing}) {
    if (newText == text) return this;
    var prefix = 0;
    final shorter = newText.length < text.length ? newText.length : text.length;
    while (prefix < shorter && newText.codeUnitAt(prefix) == text.codeUnitAt(prefix)) {
      prefix++;
    }
    var suffix = 0;
    while (suffix < shorter - prefix &&
        newText.codeUnitAt(newText.length - 1 - suffix) ==
            text.codeUnitAt(text.length - 1 - suffix)) {
      suffix++;
    }
    final inserted = newText.length - prefix - suffix;
    final mark = typing ?? (prefix > 0 ? marks[prefix - 1] : 0);
    return StyledText(newText, [
      ...marks.sublist(0, prefix),
      for (var i = 0; i < inserted; i++) mark,
      ...marks.sublist(marks.length - suffix),
    ]);
  }

  /// Whether every character from [start] to [end] has [mark].
  bool hasMark(int start, int end, int mark) {
    if (start >= end) return false;
    for (var i = start; i < end; i++) {
      if (marks[i] & mark == 0) return false;
    }
    return true;
  }

  /// Puts [mark] on the characters from [start] to [end], or takes it off
  /// when all of them have it already.
  StyledText toggle(int start, int end, int mark) {
    if (start >= end) return this;
    final on = !hasMark(start, end, mark);
    final next = [...marks];
    for (var i = start; i < end; i++) {
      next[i] = on ? next[i] | mark : next[i] & ~mark;
    }
    return StyledText(text, next);
  }

  /// The start of the line that holds [offset].
  int lineStart(int offset) {
    final before = offset <= 0 ? -1 : text.lastIndexOf('\n', offset - 1);
    return before + 1;
  }

  /// The starts of every line that touches the range.
  List<int> lineStarts(int start, int end) {
    final starts = [lineStart(start)];
    for (var i = start; i < end; i++) {
      if (text.codeUnitAt(i) == 0x0A && i + 1 <= end) starts.add(i + 1);
    }
    // A selection that ends right after a line break does not take the next
    // line along.
    if (starts.length > 1 && starts.last == end && end > start) {
      starts.removeLast();
    }
    return starts;
  }

  bool isBulleted(int lineStartOffset) => text.startsWith(bullet, lineStartOffset);

  /// Adds a bullet to every line of the range, or takes them off when all
  /// the lines have one. Gives the new text and how far each offset moved.
  (StyledText, int Function(int)) toggleBullets(int start, int end) {
    final starts = lineStarts(start, end);
    final remove = starts.every(isBulleted);
    var result = this;
    var shift = 0;
    final moves = <(int, int)>[];
    for (final line in starts) {
      final at = line + shift;
      if (remove) {
        result = result._replace(at, at + bullet.length, '');
        shift -= bullet.length;
        moves.add((line, -bullet.length));
      } else if (!result.isBulleted(at)) {
        result = result._replace(at, at, bullet);
        shift += bullet.length;
        moves.add((line, bullet.length));
      }
    }
    // An offset in the old text, in the new one. One inside a bullet that
    // went away lands where the bullet was.
    int move(int offset) {
      var by = 0;
      for (final (line, change) in moves) {
        if (change > 0) {
          if (offset >= line) by += change;
        } else if (offset >= line - change) {
          by += change;
        } else if (offset > line) {
          by -= offset - line;
        }
      }
      return offset + by;
    }

    return (result, move);
  }

  StyledText _replace(int start, int end, String insert) => StyledText(
    text.replaceRange(start, end, insert),
    [
      ...marks.sublist(0, start),
      for (var i = 0; i < insert.length; i++) 0,
      ...marks.sublist(end),
    ],
  );

  /// The first line, for the title of a folded note and of the window.
  String get firstLine {
    final line = text.trimLeft().split('\n').first.trim();
    return line.startsWith(bullet.trim())
        ? line.substring(bullet.trim().length).trim()
        : line;
  }

  @override
  bool operator ==(Object other) =>
      other is StyledText && other.text == text && listEquals(other.marks, marks);

  @override
  int get hashCode => Object.hash(text, Object.hashAll(marks));
}
