import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/core/enums/enums.dart';
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
          data: FunSliderTheme.getSliderTheme(context),
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
