import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/recurring_donations/detail/cubit/recurring_donation_detail_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

class PauseDonationBottomSheet {
  const PauseDonationBottomSheet._();

  static Future<void> show(
    BuildContext context, {
    required RecurringDonationDetailCubit cubit,
  }) {
    final locals = context.l10n;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    var selectedDate = tomorrow;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return FunBottomSheet(
              title: locals.recurringDonationsPauseSheetTitle,
              closeAction: () => Navigator.of(sheetContext).pop(),
              content: Column(
                children: [
                  BodyMediumText(
                    locals.recurringDonationsPauseSheetDescription,
                    color: FamilyAppTheme.neutral50,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FunDatePicker(
                    label: locals.recurringDonationsPauseRestartDateLabel,
                    selectedDate: selectedDate,
                    onDateSelected: (date) =>
                        setState(() => selectedDate = date),
                  ),
                ],
              ),
              primaryButton: FunButton(
                text: locals.recurringDonationsPauseContinueButton,
                analyticsEvent: AnalyticsEventName
                    .recurringDonationPauseRestartDateContinueClicked
                    .toEvent(),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  cubit.onPauseRestartDateSelected(selectedDate);
                },
              ),
            );
          },
        );
      },
    );
  }
}
