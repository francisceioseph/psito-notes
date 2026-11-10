import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../../notes/rich_controller.dart';
import '../../notes/styled_text.dart';

/// The buttons of the marks and the list, lit when the selection has them.
class FormatRow extends StatelessWidget {
  const FormatRow({super.key, required this.text, required this.ink});

  final RichTextController text;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget mark(int mark, IconData icon, String tooltip) => IconButton(
      tooltip: tooltip,
      isSelected: text.isActive(mark),
      onPressed: () => text.toggle(mark),
      icon: Icon(icon, color: ink),
      style: IconButton.styleFrom(visualDensity: VisualDensity.compact),
    );
    return ListenableBuilder(
      listenable: text,
      builder: (context, _) => Wrap(
        children: [
          mark(Mark.bold, Icons.format_bold_rounded, l10n.bold),
          mark(Mark.italic, Icons.format_italic_rounded, l10n.italic),
          mark(Mark.underline, Icons.format_underlined_rounded, l10n.underline),
          mark(Mark.strike, Icons.format_strikethrough_rounded, l10n.strike),
          IconButton(
            tooltip: l10n.bullets,
            onPressed: text.toggleBullets,
            icon: Icon(Icons.format_list_bulleted_rounded, color: ink),
            style: IconButton.styleFrom(visualDensity: VisualDensity.compact),
          ),
        ],
      ),
    );
  }
}
