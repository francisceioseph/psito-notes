import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../../notes/note.dart';
import '../../notes/note_controller.dart';
import '../../version.dart';
import '../atoms/paper.dart';
import '../labels.dart';
import '../molecules/color_row.dart';
import '../molecules/format_row.dart';

/// The paper, the font, the window and the marks, over the text of the
/// note. It scrolls, since a note can be small.
class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key, required this.note, required this.paper});

  final NoteController note;
  final Paper paper;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = note.note;
    final heading = TextStyle(
      color: paper.faint,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: .4,
    );
    final body = TextStyle(color: paper.ink, fontSize: 13);
    Widget title(String text) => Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(text.toUpperCase(), style: heading),
    );
    Widget choice(String label, bool selected, VoidCallback onTap) => ChoiceChip(
      label: Text(label, style: body),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      backgroundColor: paper.sheet,
      selectedColor: paper.strip,
      side: BorderSide(color: paper.edge.withValues(alpha: .5)),
    );
    Widget toggle(String label, bool value, ValueChanged<bool> onChanged) =>
        SwitchListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(label, style: body),
          value: value,
          onChanged: onChanged,
          activeThumbColor: paper.ink,
          activeTrackColor: paper.strip,
        );
    final sizes = sizeNames(l10n);
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
      children: [
        title(l10n.paper),
        ColorRow(current: current.color, onChanged: note.setColor),
        title(l10n.font),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final font in NoteFont.values)
              choice(
                fontName(l10n, font),
                current.font == font,
                () => note.setFont(font),
              ),
          ],
        ),
        title(l10n.textSize),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (var i = 0; i < sizes.length; i++)
              choice(sizes[i], current.textSize == i, () => note.setTextSize(i)),
          ],
        ),
        title(l10n.format),
        FormatRow(text: note.text, ink: paper.ink),
        title(l10n.window),
        toggle(l10n.onTop, current.onTop, note.setOnTop),
        toggle(l10n.translucent, current.translucent, note.setTranslucent),
        const SizedBox(height: 12),
        Text(l10n.tips, style: body.copyWith(color: paper.faint)),
        const SizedBox(height: 8),
        Text(l10n.aboutLine(appVersion), style: body.copyWith(color: paper.faint)),
        Text(l10n.aboutLegal, style: body.copyWith(color: paper.faint, fontSize: 12)),
      ],
    );
  }
}
