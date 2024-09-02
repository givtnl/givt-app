import 'package:flutter/material.dart';

class Arc extends StatelessWidget {
  final double diameter;
  final Color? color;

  const Arc({super.key, this.diameter = 200, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(color),
      size: Size(diameter, diameter / 1.6),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  final Color? color;
  MyPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color ?? Colors.blue;
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.width),
            Radius.circular(size.width / 2)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}