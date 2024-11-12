import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunSliderTheme {
  static SliderThemeData getSliderTheme(BuildContext context) {
    return SliderTheme.of(context).copyWith(
      trackHeight: 7,
      activeTrackColor: Theme.of(context).colorScheme.onInverseSurface,
      thumbShape: const SliderWidgetThumb(thumbRadius: 17),
      inactiveTrackColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      activeTickMarkColor: Theme.of(context).colorScheme.onInverseSurface,
      inactiveTickMarkColor:
          Theme.of(context).colorScheme.surfaceContainerHighest,
      valueIndicatorColor: Colors.white,
      thumbColor: Theme.of(context).colorScheme.onInverseSurface,
      disabledThumbColor: FamilyAppTheme.secondary30,
    );
  }
}

class SliderWidgetThumb extends SliderComponentShape {
  const SliderWidgetThumb({
    required this.thumbRadius,
  });
  final double thumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    // Draw circle
    final circleBluePaint = Paint()
      ..color = sliderTheme.thumbColor ?? FamilyAppTheme.secondary98
      ..style = PaintingStyle.fill;

    final circleDarkPaint = Paint()
      ..color = FamilyAppTheme.secondary30
      ..style = PaintingStyle.fill;

    // Draw shadow
    context.canvas
        .drawCircle(center + const Offset(0, 2), thumbRadius, circleDarkPaint);

    context.canvas.drawCircle(center, thumbRadius, circleBluePaint);

    // Inner circle
    context.canvas.drawCircle(center, 6, circleDarkPaint);
  }
}
