import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../notes/note_controller.dart';
import '../atoms/paper.dart';
import '../atoms/resize_grip.dart';
import '../organisms/delete_dialog.dart';
import '../organisms/note_editor.dart';
import '../organisms/note_strip.dart';
import '../organisms/settings_panel.dart';
import '../templates/note_template.dart';

/// One sticky note, filling its window.
class NotePage extends StatefulWidget {
  const NotePage({super.key, required this.note});

  final NoteController note;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _editorFocus = FocusNode();

  NoteController get note => widget.note;

  @override
  void dispose() {
    _editorFocus.dispose();
    super.dispose();
  }

  /// A note with text asks first, unless told not to; an empty one just goes.
  Future<void> _delete() async {
    if (!note.note.isEmpty && await note.store.asksBeforeDelete()) {
      if (!mounted) return;
      final answer = await askToDelete(context);
      if (!answer.delete) return;
      if (!answer.askAgain) await note.store.setAsksBeforeDelete(false);
    }
    await note.delete();
  }

  void _toggleSettings() {
    note.toggleSettings();
    if (!note.showingSettings) _editorFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) => CallbackShortcuts(
    bindings: {
      const SingleActivator(LogicalKeyboardKey.keyN, control: true):
          note.newNote,
      const SingleActivator(LogicalKeyboardKey.keyD, control: true): _delete,
    },
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: ListenableBuilder(
        listenable: note,
        builder: (context, _) {
          final current = note.note;
          final paper = Paper.of(current.color);
          return NoteTemplate(
            paper: paper,
            folded: current.folded,
            strip: NoteStrip(
              paper: paper,
              title: current.body.firstLine,
              folded: current.folded,
              settingsOpen: note.showingSettings,
              onNew: note.newNote,
              onMove: note.window.startMove,
              onFold: note.toggleFold,
              onSettings: _toggleSettings,
              onDelete: _delete,
            ),
            // The editor stays under the settings, so the caret and the
            // undo are still there when they close.
            body: Stack(
              children: [
                Positioned.fill(
                  child: Offstage(
                    offstage: note.showingSettings,
                    child: NoteEditor(
                      text: note.text,
                      note: current,
                      paper: paper,
                      focusNode: _editorFocus,
                      onBigger: note.biggerText,
                      onSmaller: note.smallerText,
                    ),
                  ),
                ),
                if (note.showingSettings)
                  Positioned.fill(
                    child: SettingsPanel(note: note, paper: paper),
                  ),
              ],
            ),
            grip: ResizeGrip(
              color: paper.faint,
              onStart: note.window.startResize,
            ),
          );
        },
      ),
    ),
  );
}
