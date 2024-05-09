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
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: AppTheme.givtLightBackgroundGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              width: 2,
              color: AppTheme.childGivingAllowanceCardBorder,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
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
                      text: profileDetails.givingAllowance.amount
                          .toStringAsFixed(0),
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
                      context.l10n.createChildGivingAllowanceTitle,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppTheme.inputFieldBorderSelected,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w800,
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
          ),
        ),
      ),
    );
  }
}
