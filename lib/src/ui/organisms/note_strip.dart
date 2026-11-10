import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../../platform/note_window.dart';
import '../atoms/paper.dart';
import '../atoms/strip_button.dart';

/// The strip at the top of a note: a new note, the handle that moves the
/// window and folds it with a double click, the settings and the bin.
class NoteStrip extends StatelessWidget {
  const NoteStrip({
    super.key,
    required this.paper,
    required this.title,
    required this.folded,
    required this.settingsOpen,
    required this.onNew,
    required this.onMove,
    required this.onFold,
    required this.onSettings,
    required this.onDelete,
  });

  final Paper paper;

  /// The first line, shown while the note is folded.
  final String title;
  final bool folded;
  final bool settingsOpen;
  final VoidCallback onNew;
  final VoidCallback onMove;
  final VoidCallback onFold;
  final VoidCallback onSettings;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      height: stripHeight,
      color: paper.strip,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        children: [
          StripButton(
            tooltip: l10n.newNote,
            icon: Icons.add_rounded,
            color: paper.ink,
            onPressed: onNew,
          ),
          Expanded(
            child: Semantics(
              button: true,
              label: l10n.foldNote,
              onTap: onFold,
              child: GestureDetector(
                excludeFromSemantics: true,
                behavior: HitTestBehavior.opaque,
                onPanStart: (_) => onMove(),
                onDoubleTap: onFold,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: folded
                      ? Text(
                          title.isEmpty ? l10n.emptyNote : title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: paper.ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : const SizedBox.expand(),
                ),
              ),
            ),
          ),
          if (!folded)
            StripButton(
              tooltip: settingsOpen ? l10n.backToNote : l10n.settings,
              icon: settingsOpen ? Icons.edit_note_rounded : Icons.palette_outlined,
              color: paper.ink,
              onPressed: onSettings,
            ),
          StripButton(
            tooltip: l10n.deleteNote,
            icon: Icons.close_rounded,
            color: paper.ink,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
