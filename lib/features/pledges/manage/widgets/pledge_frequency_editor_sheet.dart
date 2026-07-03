import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_frequency_dropdown.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';
import 'package:givt_app/features/pledges/manage/cubit/pledge_manage_cubit.dart';
import 'package:givt_app/features/pledges/shared/pledge_display.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

class PledgeFrequencyEditorSheet {
  const PledgeFrequencyEditorSheet._();

  static Future<void> show(
    BuildContext context, {
    required PledgeManageCubit cubit,
    required PledgeManageUIModel uiModel,
  }) {
    final locals = context.l10n;
    final group = uiModel.group;
    final currentFrequency = group.goals.firstOrNull?.frequency ?? 'Monthly';
    final parsedFrequency =
        PledgeDisplay.parseFrequency(currentFrequency) ??
            ExternalDonationFrequency.monthly;
    var frequency = ExternalDonationFrequencyDropdown.frequencyForEditor(
      parsedFrequency,
    );

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
            final canSave =
                PledgeDisplay.toApiFrequency(frequency) != currentFrequency;

            return FunBottomSheet(
              title: locals.pledgesEditFrequencyLabel,
              closeAction: () => Navigator.of(sheetContext).pop(),
              content: ExternalDonationFrequencyDropdown(
                value: frequency,
                frequencies: manageRecurringFrequencies,
                label: locals.pledgesEditFrequencyLabel,
                onChanged: (value) => setState(() => frequency = value),
              ),
              primaryButton: FunButton(
                text: locals.pledgesEditSaveButton,
                isDisabled: !canSave,
                isLoading: uiModel.isSaving,
                analyticsEvent:
                    AnalyticsEventName.pledgesEditFrequencySaveClicked.toEvent(),
                onTap: canSave && !uiModel.isSaving
                    ? () async {
                        Navigator.of(sheetContext).pop();
                        await cubit.saveFrequency(
                          frequency: PledgeDisplay.toApiFrequency(frequency),
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
