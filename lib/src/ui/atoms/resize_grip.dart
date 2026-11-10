import 'package:flutter/material.dart';

/// The corner that resizes the note when dragged. It is not a control for
/// screen readers: the window can be resized by the system too.
class ResizeGrip extends StatelessWidget {
  const ResizeGrip({super.key, required this.color, required this.onStart});

  final Color color;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.resizeDownRight,
    child: GestureDetector(
      excludeFromSemantics: true,
      behavior: HitTestBehavior.opaque,
      onPanStart: (_) => onStart(),
      child: SizedBox(
        width: 18,
        height: 18,
        child: CustomPaint(painter: _GripPainter(color)),
      ),
    ),
  );
}

class _GripPainter extends CustomPainter {
  const _GripPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    for (final step in [5.0, 9.0, 13.0]) {
      canvas.drawLine(
        Offset(size.width - 3, size.height - step),
        Offset(size.width - step, size.height - 3),
        line,
      );
    }
  }

  @override
  bool shouldRepaint(_GripPainter old) => old.color != color;
}
