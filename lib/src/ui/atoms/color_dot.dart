import 'package:flutter/material.dart';

/// A round swatch of a paper, ringed when it is the chosen one.
class ColorDot extends StatelessWidget {
  const ColorDot({
    super.key,
    required this.label,
    required this.color,
    required this.ring,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Color ring;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: label,
    child: Semantics(
      button: true,
      selected: selected,
      label: label,
      onTap: onTap,
      child: InkResponse(
        excludeFromSemantics: true,
        onTap: onTap,
        radius: 18,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: ring,
              width: selected ? 2.5 : 1,
            ),
          ),
          child: selected
              ? Icon(Icons.check_rounded, size: 16, color: ring)
              : null,
        ),
      ),
    ),
  );
}
