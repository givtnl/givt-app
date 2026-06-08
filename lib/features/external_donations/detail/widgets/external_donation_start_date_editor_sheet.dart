import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_past_date_picker.dart';
import 'package:givt_app/features/external_donations/detail/cubit/external_donation_detail_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/util.dart';
import 'package:intl/intl.dart';

class ExternalDonationStartDateEditorSheet {
  const ExternalDonationStartDateEditorSheet._();

  static Future<void> show(
    BuildContext context, {
    required ExternalDonationDetailCubit cubit,
    required ExternalDonationDetailUIModel uiModel,
  }) {
    final locals = context.l10n;
    final locale = Util.getLanguageTageFromLocale(context);
    final donation = uiModel.donation;
    var selectedDate = donation.startDateTime;
    final initialDate = selectedDate;

    String infoText() {
      if (selectedDate == null) {
        return '';
      }
      final monthYear = DateFormat.yMMMM(locale).format(selectedDate!);
      return locals.externalDonationsEditStartDateInfo(monthYear);
    }

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
              title: locals.externalDonationsManageStartDate,
              closeAction: () => Navigator.of(sheetContext).pop(),
              content: Column(
                children: [
                  ExternalDonationPastDatePicker(
                    label: locals.externalDonationsManageStartDate,
                    selectedDate: selectedDate,
                    onDateSelected: (date) =>
                        setState(() => selectedDate = date),
                  ),
                  const SizedBox(height: 16),
                  BodySmallText(
                    infoText(),
                    color: FamilyAppTheme.neutral50,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              primaryButton: FunButton(
                text: locals.externalDonationsSave,
                isDisabled: !hasChanged,
                isLoading: uiModel.isSaving,
                analyticsEvent: AnalyticsEventName
                    .externalDonationsEditStartDateSaveClicked
                    .toEvent(),
                onTap: hasChanged && !uiModel.isSaving && selectedDate != null
                    ? () async {
                        Navigator.of(sheetContext).pop();
                        await cubit.saveStartDate(selectedDate!);
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
