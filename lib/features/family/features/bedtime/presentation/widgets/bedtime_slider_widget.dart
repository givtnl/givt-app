import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/bedtime.dart';
import 'package:givt_app/features/family/shared/design/components/input/input.dart';
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
  late double currentAmount;

  @override
  void initState() {
    super.initState();
    currentAmount = widget.initialAmount ?? BedtimeConfig().defaultBedtimeHour;
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
          data: FunSliderTheme.getSliderTheme(context),
          child: Slider(
            min: BedtimeConfig().minBedtimeHour,
            value: currentAmount,
            max: BedtimeConfig().maxBedtimeHour,
            divisions: BedtimeConfig().sliderDivisionsCount,
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
    final minutes = ((amount - amount.floor()) * 60).round();
    return minutes.toString().padLeft(2, '0');
  }
}
