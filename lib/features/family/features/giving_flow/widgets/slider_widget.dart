import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app/features/family/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_slider.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
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
          data: FunSliderTheme.getSliderTheme(context),
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
