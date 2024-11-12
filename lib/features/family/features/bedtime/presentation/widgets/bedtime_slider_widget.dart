import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/utils/utils.dart';

class BedtimeSliderWidget extends StatefulWidget {
  BedtimeSliderWidget({
    this.initialAmount,
    this.onAmountChanged,
    super.key,
  });

  final double? initialAmount;
  final void Function(double amount)? onAmountChanged;
  @override
  State<BedtimeSliderWidget> createState() => _BedtimeSliderWidgetState();
}

class _BedtimeSliderWidgetState extends State<BedtimeSliderWidget> {
  double currentAmount = 7.0;

  @override
  void initState() {
    super.initState();
    currentAmount = widget.initialAmount ?? 7.0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: HeadlineLargeText(
            '${currentAmount.floor()}:${getMinutes(currentAmount)} pm',
            color: FamilyAppTheme.primary99,
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 7,
            activeTrackColor: Theme.of(context).colorScheme.onInverseSurface,
            thumbShape: const SliderWidgetThumb(thumbRadius: 17),
            inactiveTrackColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            activeTickMarkColor: Theme.of(context).colorScheme.onInverseSurface,
            inactiveTickMarkColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            valueIndicatorColor: Colors.white,
            thumbColor: Theme.of(context).colorScheme.onInverseSurface,
            disabledThumbColor: FamilyAppTheme.secondary30,
          ),
          child: Slider(
            min: 6,
            value: currentAmount,
            max: 9.5,
            divisions:
                7, // there are 7 blocks of 30 minutes blocks between 6:30 and 9 pm
            onChanged: (value) {
              widget.onAmountChanged?.call(value);
              HapticFeedback.lightImpact();
              setState(() {
                currentAmount = value;
              });
            },
            onChangeEnd: (value) {
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.amountPressed,
                eventProperties: {
                  AnalyticsHelper.amountKey: value.roundToDouble(),
                },
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              LabelMediumText(
                '6:00 pm',
                color: FamilyAppTheme.primary99,
              ),
              Spacer(),
              LabelMediumText(
                '9:30 pm',
                color: FamilyAppTheme.primary99,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getMinutes(double amount) {
    final commaValues = amount - amount.floor();
    if (commaValues == 0.5) {
      return '30';
    }
    return '00';
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
      ..color = sliderTheme.thumbColor!
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
