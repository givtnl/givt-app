import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/recurring_donations/cancel/widgets/cancel_recurring_donation_confirmation_dialog.dart';
import 'package:givt_app/features/recurring_donations/detail/cubit/recurring_donation_detail_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/overview/pages/recurring_donations_overview_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
class RecurringDonationDetailManageSheet {
  const RecurringDonationDetailManageSheet._();

  static Future<void> show(
    BuildContext context, {
    required RecurringDonationDetailCubit cubit,
    required RecurringDonation recurringDonation,
  }) {
    final locals = context.l10n;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return FunBottomSheet(
          title: locals.recurringDonationsDetailManageButton,
          closeAction: () => Navigator.of(sheetContext).pop(),
          content: Column(
            children: [
              FunButton(
                text: locals.recurringDonationsDetailEditDonation,
                variant: FunButtonVariant.secondary,
                fullBorder: true,
                analyticsEvent:
                    AnalyticsEventName.recurringDonationEditActionClicked
                        .toEvent(),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        locals.recurringDonationsDetailEditComingSoon,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              FunButton(
                text: locals.recurringDonationsDetailPauseDonation,
                variant: FunButtonVariant.secondary,
                fullBorder: true,
                analyticsEvent:
                    AnalyticsEventName.recurringDonationPauseActionClicked
                        .toEvent(),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  cubit.onPauseDonationPressed();
                },
              ),
              const SizedBox(height: 12),
              FunButton(
                text: locals.recurringDonationsDetailCancelDonation,
                variant: FunButtonVariant.secondary,
                fullBorder: true,
                borderColor: FamilyAppTheme.error40,
                textColor: FamilyAppTheme.error40,
                analyticsEvent:
                    AnalyticsEventName.recurringDonationCancelActionClicked
                        .toEvent(),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  showDialog<bool>(
                    context: context,
                    builder: (dialogContext) =>
                        CancelRecurringDonationConfirmationDialog(
                      recurringDonation: recurringDonation,
                    ),
                  ).then((result) {
                    if (result == true && context.mounted) {
                      Navigator.of(context).push(
                        const RecurringDonationsOverviewPage().toRoute(context),
                      );
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
