import 'package:flutter/material.dart';
import 'package:givt_app/features/children/details/models/profile_ext.dart';
import 'package:givt_app/features/children/utils/child_date_utils.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
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
    final theme = FamilyAppTheme().toThemeData();
    final size = MediaQuery.of(context).size;
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
            theme: theme,
            size: size,
          ),
        ),
      ),
    );
  }

  Widget getLayout(
    BuildContext context, {
    required bool hasAllowance,
    required DateTime nextTopUpDate,
    required Size size,
    ThemeData? theme,
  }) {
    if (hasAllowance) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          primaryCircleWithText(
            circleSize: size.width * 0.35,
            text:
                '\$${profileDetails.givingAllowance.amount.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 16),
          Text(
            textAlign: TextAlign.center,
            'Recurring Amount',
            style: theme?.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            (profileDetails.pendingAllowance)
                ? '${context.l10n.editChildWeWIllTryAgain}${ChildDateUtils.dateFormatter.format(nextTopUpDate)}'
                : 'Next due: ${ChildDateUtils.dateFormatter.format(nextTopUpDate)}',
            style: theme?.textTheme.bodySmall,
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        calendarClockAvatarIcon(
          width: size.width * 0.35,
          height: size.width * 0.35,
        ),
        const SizedBox(height: 16),
        Text(
          textAlign: TextAlign.center,
          'Recurring Amount',
          style: theme?.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Build a habit of generosity',
          textAlign: TextAlign.center,
          style: theme?.textTheme.bodySmall,
        ),
      ],
    );
  }
}
