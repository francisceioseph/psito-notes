import 'package:flutter/material.dart';

import '../atoms/paper.dart';

/// A sheet of paper: the strip on top and, unless folded, the body with the
/// resize corner.
class NoteTemplate extends StatelessWidget {
  const NoteTemplate({
    super.key,
    required this.paper,
    required this.strip,
    required this.body,
    required this.grip,
    required this.folded,
  });

  final Paper paper;
  final Widget strip;
  final Widget body;
  final Widget grip;
  final bool folded;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [paper.sheet, paper.deep],
      ),
      border: Border.all(color: paper.edge.withValues(alpha: .6)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        strip,
        if (!folded)
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: body),
                Positioned(right: 0, bottom: 0, child: grip),
              ],
            ),
          ),
      ],
    ),
  );
}
