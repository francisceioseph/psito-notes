import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/l10n.dart';
import '../../notes/note.dart';
import '../../notes/rich_controller.dart';
import '../../notes/styled_text.dart';
import '../atoms/paper.dart';

/// The text of the note, with the shortcuts of the classic sticky notes.
class NoteEditor extends StatelessWidget {
  const NoteEditor({
    super.key,
    required this.text,
    required this.note,
    required this.paper,
    required this.onBigger,
    required this.onSmaller,
    this.focusNode,
  });

  final RichTextController text;
  final Note note;
  final Paper paper;
  final VoidCallback onBigger;
  final VoidCallback onSmaller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final size = textSizes[note.textSize] * fontScale(note.font);
    final style = TextStyle(
      fontFamily: fontFamily(note.font),
      fontSize: size,
      height: 1.25,
      color: paper.ink,
    );
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyB, control: true): () =>
            text.toggle(Mark.bold),
        const SingleActivator(LogicalKeyboardKey.keyI, control: true): () =>
            text.toggle(Mark.italic),
        const SingleActivator(LogicalKeyboardKey.keyU, control: true): () =>
            text.toggle(Mark.underline),
        const SingleActivator(LogicalKeyboardKey.keyT, control: true): () =>
            text.toggle(Mark.strike),
        const SingleActivator(
          LogicalKeyboardKey.keyL,
          control: true,
          shift: true,
        ): text.toggleBullets,
        const SingleActivator(LogicalKeyboardKey.keyY, control: true): text.redo,
        // The keyboards give either the key or its character.
        const SingleActivator(
          LogicalKeyboardKey.period,
          control: true,
          shift: true,
        ): onBigger,
        const SingleActivator(
          LogicalKeyboardKey.greater,
          control: true,
          shift: true,
        ): onBigger,
        const SingleActivator(
          LogicalKeyboardKey.comma,
          control: true,
          shift: true,
        ): onSmaller,
        const SingleActivator(
          LogicalKeyboardKey.less,
          control: true,
          shift: true,
        ): onSmaller,
      },
      // The undo of the field forgets the marks, so the note's own takes
      // its place.
      child: Actions(
        actions: {
          UndoTextIntent: CallbackAction<UndoTextIntent>(
            onInvoke: (_) => text.undo(),
          ),
          RedoTextIntent: CallbackAction<RedoTextIntent>(
            onInvoke: (_) => text.redo(),
          ),
        },
        child: Semantics(
          label: l10n.noteText,
          textField: true,
          child: TextField(
            controller: text,
            focusNode: focusNode,
            autofocus: true,
            expands: true,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textAlignVertical: TextAlignVertical.top,
            cursorColor: paper.ink,
            style: style,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: l10n.writeHere,
              hintStyle: style.copyWith(color: paper.faint),
              contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              isCollapsed: true,
            ),
          ),
        ),
      ),
    );
  }
}
