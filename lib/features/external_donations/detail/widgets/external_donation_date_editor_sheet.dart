import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_past_date_picker.dart';
import 'package:givt_app/features/external_donations/detail/cubit/external_donation_detail_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

class ExternalDonationDateEditorSheet {
  const ExternalDonationDateEditorSheet._();

  static Future<void> show(
    BuildContext context, {
    required ExternalDonationDetailCubit cubit,
    required ExternalDonationDetailUIModel uiModel,
  }) {
    final locals = context.l10n;
    final donation = uiModel.donation;
    var selectedDate = donation.startDateTime;
    final initialDate = selectedDate;

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
            final hasChanged = selectedDate != null &&
                (initialDate == null ||
                    selectedDate!.year != initialDate.year ||
                    selectedDate!.month != initialDate.month ||
                    selectedDate!.day != initialDate.day);

            return FunBottomSheet(
              title: locals.externalDonationsDetailOneOffDate,
              closeAction: () => Navigator.of(sheetContext).pop(),
              content: ExternalDonationPastDatePicker(
                label: locals.externalDonationsDetailOneOffDate,
                selectedDate: selectedDate,
                onDateSelected: (date) => setState(() => selectedDate = date),
              ),
              primaryButton: FunButton(
                text: locals.externalDonationsSave,
                isDisabled: !hasChanged,
                isLoading: uiModel.isSaving,
                analyticsEvent:
                    AnalyticsEventName.externalDonationsEditDateSaveClicked
                        .toEvent(),
                onTap: hasChanged && !uiModel.isSaving && selectedDate != null
                    ? () async {
                        Navigator.of(sheetContext).pop();
                        await cubit.saveOneOffDate(selectedDate!);
                      }
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
