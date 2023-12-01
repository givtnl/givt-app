import 'package:flutter/material.dart';

class InvertedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 4),
            radius: size.width - 180,
          ),
        )
        ..close(),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
