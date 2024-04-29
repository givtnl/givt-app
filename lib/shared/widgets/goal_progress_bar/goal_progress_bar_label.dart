import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalProgressBarLabel extends StatelessWidget {
  const GoalProgressBarLabel({
    required this.text,
    required this.backgroundColor,
    this.isBold = false,
    this.isCenterAnchor = false,
    super.key,
  });

  const GoalProgressBarLabel.amount(
    int amount, {
    required this.backgroundColor,
    this.isBold = false,
    this.isCenterAnchor = false,
    super.key,
  }) : text = '\$$amount';

  final String text;
  final Color backgroundColor;
  final bool isBold;
  final bool isCenterAnchor;

  @override
  Widget build(BuildContext context) {
    final renderObject = context.findRenderObject();
    final ownSize =
        renderObject != null ? (renderObject as RenderBox).size : Size.zero;
    final xOffset = isCenterAnchor ? -(ownSize.width / 2) : 0.0;

    return Transform.translate(
      offset: Offset(xOffset, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          text,
          style: GoogleFonts.mulish(
            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}
