import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class PersonalSummaryStickyActions extends StatelessWidget {
  const PersonalSummaryStickyActions({
    required this.hasGivingGoal,
    required this.onAddDonation,
    required this.onSetGivingGoal,
    super.key,
  });

  final bool hasGivingGoal;
  final VoidCallback onAddDonation;
  final VoidCallback onSetGivingGoal;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final theme = FunTheme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + bottomInset),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: theme.neutral90)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FunButton(
            text: locals.personalSummaryAddDonation,
            analyticsEvent: AnalyticsEvent(
              AnalyticsEventName.personalSummaryAddDonationClicked,
            ),
            onTap: onAddDonation,
          ),
          if (!hasGivingGoal) ...[
            const SizedBox(height: 12),
            FunButton(
              text: locals.personalSummarySetGivingGoal,
              variant: FunButtonVariant.secondary,
              analyticsEvent: AnalyticsEvent(
                AnalyticsEventName.setGivingGoalClicked,
              ),
              onTap: onSetGivingGoal,
            ),
          ],
        ],
      ),
    );
  }
}
