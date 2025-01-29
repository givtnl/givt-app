import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {

  TrianglePainter({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.stroke,
    this.offset = Offset.zero,
  });
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final Offset offset;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(offset.dx, offset.dy)
      ..lineTo((x/ 2)+offset.dx, y+offset.dy)
      ..lineTo((x+offset.dx), offset.dy)
      ..lineTo(offset.dx, offset.dy);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.offset != offset;
  }
}
