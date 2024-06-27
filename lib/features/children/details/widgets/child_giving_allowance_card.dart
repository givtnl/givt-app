import 'package:flutter/material.dart';
import 'package:givt_app/features/children/details/models/profile_ext.dart';
import 'package:givt_app/features/children/utils/child_date_utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/utils.dart';

class ChildGivingAllowanceCard extends StatelessWidget {
  const ChildGivingAllowanceCard({
    required this.profileDetails,
    this.onPressed,
    super.key,
  });

  final ProfileExt profileDetails;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final nextTopUpDate =
        DateTime.parse(profileDetails.givingAllowance.nextGivingAllowanceDate);

    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            width: 2,
            color: AppTheme.childGivingAllowanceCardBorder,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: SizedBox(
          width: double.maxFinite,
          child: getLayout(
            context,
            hasAllowance: profileDetails.givingAllowance.amount > 0,
            nextTopUpDate: nextTopUpDate,
          ),
        ),
      ),
    );
  }

  Widget getLayout(BuildContext context,
      {required bool hasAllowance, required DateTime nextTopUpDate}) {
    if (hasAllowance) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w800,
                    color: AppTheme.inputFieldBorderSelected,
                  ),
              children: [
                TextSpan(
                  text: r'$',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.inputFieldBorderSelected,
                      ),
                ),
                TextSpan(
                  text:
                      profileDetails.givingAllowance.amount.toStringAsFixed(0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              calendarClockIcon(width: 23, height: 20),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  textAlign: TextAlign.center,
                  context.l10n.createChildGivingAllowanceTitle,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppTheme.inputFieldBorderSelected,
                        fontFamily: 'Raleway',
                        height: 1.2,
                      ),
                ),
              ),
            ],
          ),
          Text(
            (profileDetails.pendingAllowance)
                ? '${context.l10n.editChildWeWIllTryAgain}${ChildDateUtils.dateFormatter.format(nextTopUpDate)}'
                : '${context.l10n.childNextTopUpPrefix}${ChildDateUtils.dateFormatter.format(nextTopUpDate)}',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppTheme.childGivingAllowanceHint,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 1.2,
                ),
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        calendarClockIcon(width: 40, height: 40),
        const SizedBox(height: 10),
        Text(
          textAlign: TextAlign.center,
          context.l10n.createChildGivingAllowanceTitle,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: AppTheme.inputFieldBorderSelected,
                fontFamily: 'Raleway',
                height: 1.2,
              ),
        ),
        Text(
          'Set an amount that your child\nwill receive each month',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppTheme.childGivingAllowanceHint,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.2,
              ),
        ),
      ],
    );
  }
}
