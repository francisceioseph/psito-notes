import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../../notes/note.dart';
import '../atoms/color_dot.dart';
import '../atoms/paper.dart';
import '../labels.dart';

/// The six papers to choose from.
class ColorRow extends StatelessWidget {
  const ColorRow({super.key, required this.current, required this.onChanged});

  final NoteColor current;
  final ValueChanged<NoteColor> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final color in NoteColor.values)
          ColorDot(
            label: colorName(l10n, color),
            color: Paper.of(color).sheet,
            ring: Paper.of(color).edge,
            selected: color == current,
            onTap: () => onChanged(color),
          ),
      ],
    );
  }
}
