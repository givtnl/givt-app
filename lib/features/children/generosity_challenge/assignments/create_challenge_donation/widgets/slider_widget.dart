import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/create_challenge_donation/cubit/create_challenge_donation_cubit.dart';
import 'package:givt_app/utils/utils.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({
    required this.maxAmount,
    this.currentAmount = 0,
    super.key,
  });

  final double currentAmount;
  final double maxAmount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              '\$${currentAmount.round()}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppTheme.secondary30,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rouna',
                  ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 7,
              activeTrackColor: AppTheme.secondary80,
              thumbShape: const SliderWidgetThumb(thumbRadius: 17),
              inactiveTrackColor: AppTheme.neutralVariant90,
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
              valueIndicatorColor: Colors.white,
              thumbColor: AppTheme.secondary80,
              disabledThumbColor: AppTheme.secondary30,
            ),
            child: Slider(
              value: currentAmount,
              max: maxAmount,
              divisions: maxAmount.round(),
              onChanged: (value) {
                HapticFeedback.lightImpact();
                context
                    .read<CreateChallengeDonationCubit>()
                    .updateAmount(value);
              },
              onChangeEnd: (value) {
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.sliderAmountChanged,
                  eventProperties: {'amount': value.toInt()},
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                _createLabel(context, r'$0'),
                const Spacer(),
                _createLabel(context, '\$${maxAmount.round()}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppTheme.primary20,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            fontFamily: 'Rouna',
          ),
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
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    final circleDarkPaint = Paint()
      ..color = AppTheme.secondary30
      ..style = PaintingStyle.fill;

    // Draw shadow
    context.canvas
        .drawCircle(center + const Offset(0, 2), thumbRadius, circleDarkPaint);

    context.canvas.drawCircle(center, thumbRadius, circleBluePaint);

    // Inner circle
    context.canvas.drawCircle(center, 6, circleDarkPaint);
  }
}
