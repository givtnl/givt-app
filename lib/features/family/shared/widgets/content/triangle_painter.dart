import 'package:flutter/material.dart';

enum TriangleDirection { up, down }

class TrianglePainter extends CustomPainter {

  TrianglePainter({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.stroke,
    this.offset = Offset.zero,
    this.direction = TriangleDirection.down,
  });
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final Offset offset;
  final TriangleDirection direction;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    switch (direction) {
      case TriangleDirection.up:
        return _getUpTrianglePath(x, y);
      case TriangleDirection.down:
        return _getDownTrianglePath(x, y);
    }

  }

  Path _getUpTrianglePath(double x, double y) {
    return Path()
      ..moveTo(offset.dx, y + offset.dy)
      ..lineTo((x / 2) + offset.dx, offset.dy)
      ..lineTo(x + offset.dx, y + offset.dy)
      ..lineTo(offset.dx, y + offset.dy);
  }

  Path _getDownTrianglePath(double x, double y) {
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
