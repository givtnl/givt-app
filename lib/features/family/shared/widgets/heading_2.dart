import 'package:flutter/material.dart';

class Heading2 extends StatelessWidget {
  const Heading2({
    super.key,
    required this.text,
    this.alignment = TextAlign.start,
  });
  final String text;
  final TextAlign alignment;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Text(
        text,
        textAlign: alignment,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: Color(0xFF3B3240),
        ),
      ),
    );
  }
}
