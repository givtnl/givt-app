import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app/features/family/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/utils/utils.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget(
    this.currentAmount,
    this.maxAmount, {
    super.key,
  });
  final double currentAmount;
  final double maxAmount;

  @override
  Widget build(BuildContext context) {
    if (maxAmount == 0) {
      return const CustomCircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: HeadlineLargeText(
            '\$${currentAmount.round()}',
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
            value: currentAmount,
            max: maxAmount,
            divisions: maxAmount.round(),
            onChanged: (value) {
              HapticFeedback.lightImpact();
              context.read<ScanNfcCubit>().stopScanningSession();
              context.read<CreateTransactionCubit>().changeAmount(value);
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              Text(
                r'$0',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const Spacer(),
              Text(
                '\$${maxAmount.round()}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ],
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
