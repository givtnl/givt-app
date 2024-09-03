import 'package:flutter/material.dart';
import 'package:givt_app/features/children/overview/widgets/models/edit_allowance_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:givt_app/utils/app_theme.dart';

class EditAllowanceWidget extends StatelessWidget {
  const EditAllowanceWidget({
    required this.uiModel,
    this.onAllowanceChanged,
    super.key,
  });

  final EditAllowanceUIModel uiModel;
  final void Function(int allowance)? onAllowanceChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Align(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  context.l10n.createChildGivingAllowanceTitle,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppTheme.inputFieldBorderSelected,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Which amount should be added to',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppTheme.childGivingAllowanceHint,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.2,
                      ),
                ),
                Text(
                  "your child's wallet each month?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppTheme.childGivingAllowanceHint,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.2,
                      ),
                ),
                const SizedBox(height: 10),
                FunCounter(
                  currency: uiModel.currency,
                  initialAmount: uiModel.initialAllowance,
                  onAmountChanged: onAllowanceChanged,
                ),
                const SizedBox(height: 10),
                Text(
                  'Choose an amount between ${uiModel.currency}1 and '
                  '${uiModel.currency}999.',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppTheme.childGivingAllowanceHint,
                      ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:
                CustomElevatedButton(title: 'Confirm', onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
