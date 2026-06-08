import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_frequency_dropdown.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_past_date_picker.dart';
import 'package:givt_app/features/external_donations/detail/cubit/external_donation_detail_cubit.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_update_scope.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_display.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/util.dart';

class ExternalDonationFrequencyEditorSheet {
  const ExternalDonationFrequencyEditorSheet._();

  static Future<void> show(
    BuildContext context, {
    required ExternalDonationDetailCubit cubit,
    required ExternalDonationDetailUIModel uiModel,
    required ExternalDonationUpdateScope scope,
  }) {
    final locals = context.l10n;
    final locale = Util.getLanguageTageFromLocale(context);
    final donation = uiModel.donation;
    var frequency = donation.frequency == ExternalDonationFrequency.once
        ? ExternalDonationFrequency.monthly
        : donation.frequency;
    var anchorDate = donation.startDateTime ?? DateTime.now();
    final initialFrequency = frequency;
    final initialAnchorDate = anchorDate;

    String infoText() {
      final frequencyLabel = ExternalDonationDisplay.formatFrequencyWithDay(
        locals: locals,
        frequency: frequency,
        anchorDate: anchorDate,
        locale: locale,
      );
      final nextDate = donation.nextRecurringOccurrenceDate ?? anchorDate;
      final formattedDate =
          ExternalDonationDisplay.formatDate(nextDate, locale);
      return switch (scope) {
        ExternalDonationUpdateScope.all =>
          locals.externalDonationsEditFrequencyInfoAll(frequencyLabel),
        ExternalDonationUpdateScope.onwards =>
          locals.externalDonationsEditFrequencyInfoOnwards(
            formattedDate,
            frequencyLabel,
          ),
      };
    }

    bool hasChanged() {
      if (scope == ExternalDonationUpdateScope.onwards) {
        return frequency != initialFrequency;
      }
      return frequency != initialFrequency ||
          anchorDate.day != initialAnchorDate.day ||
          anchorDate.month != initialAnchorDate.month ||
          anchorDate.year != initialAnchorDate.year;
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
            final canSave = hasChanged();

            return FunBottomSheet(
              title: locals.externalDonationsManageFrequency,
              closeAction: () => Navigator.of(sheetContext).pop(),
              content: Column(
                children: [
                  ExternalDonationFrequencyDropdown(
                    value: frequency,
                    onChanged: (value) => setState(() => frequency = value),
                  ),
                  if (scope == ExternalDonationUpdateScope.all) ...[
                    const SizedBox(height: 16),
                    ExternalDonationPastDatePicker(
                      label: locals.externalDonationsManageFrequencyDayLabel,
                      selectedDate: anchorDate,
                      onDateSelected: (date) =>
                          setState(() => anchorDate = date),
                    ),
                  ],
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
                isDisabled: !canSave,
                isLoading: uiModel.isSaving,
                analyticsEvent: AnalyticsEventName
                    .externalDonationsEditFrequencySaveClicked
                    .toEvent(),
                onTap: canSave && !uiModel.isSaving
                    ? () async {
                        Navigator.of(sheetContext).pop();
                        await cubit.saveFrequency(
                          frequency: frequency,
                          anchorDate: anchorDate,
                          scope: scope,
                        );
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
