import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/pledges/manage/cubit/pledge_manage_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

class PledgeGivingMethodEditorSheet {
  const PledgeGivingMethodEditorSheet._();

  static const _onlineType = 'Online';
  static const _directDebitType = 'DirectDebit';

  static Future<void> show(
    BuildContext context, {
    required PledgeManageCubit cubit,
    required PledgeManageUIModel uiModel,
  }) {
    final locals = context.l10n;
    final currentType = uiModel.group.goals.firstOrNull?.type ?? _onlineType;
    var selectedType = currentType == _directDebitType
        ? _directDebitType
        : _onlineType;

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
            final auth = context.read<AuthCubit>().state.user;
            final hasBankDetails =
                auth.iban.isNotEmpty || auth.accountNumber.isNotEmpty;
            final missingBankDetails =
                selectedType == _directDebitType && !hasBankDetails;
            final canSave = selectedType != currentType && !missingBankDetails;

            return FunBottomSheet(
              title: locals.pledgesEditGivingMethodLabel,
              closeAction: () => Navigator.of(sheetContext).pop(),
              content: Column(
                children: [
                  _GivingMethodOption(
                    title: locals.onlineGivingLabel,
                    isSelected: selectedType == _onlineType,
                    onTap: () => setState(() => selectedType = _onlineType),
                  ),
                  _GivingMethodOption(
                    title: locals.pledgesGivingMethodAutomaticCollection,
                    isSelected: selectedType == _directDebitType,
                    onTap: () =>
                        setState(() => selectedType = _directDebitType),
                  ),
                  if (missingBankDetails) ...[
                    const SizedBox(height: 8),
                    BodySmallText(
                      locals.pledgesEditValidationBankDetailsRequired,
                      color: FamilyAppTheme.error80,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
              primaryButton: FunButton(
                text: locals.pledgesEditSaveButton,
                isDisabled: !canSave,
                isLoading: uiModel.isSaving,
                analyticsEvent: AnalyticsEventName
                    .pledgesEditGivingMethodSaveClicked
                    .toEvent(),
                onTap: canSave && !uiModel.isSaving
                    ? () async {
                        Navigator.of(sheetContext).pop();
                        await cubit.saveGivingMethod(type: selectedType);
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

class _GivingMethodOption extends StatelessWidget {
  const _GivingMethodOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? theme.primary40 : theme.neutralVariant80,
                width: isSelected ? 2 : 1,
              ),
              color: isSelected ? theme.primary99 : theme.neutralVariant99,
            ),
            child: Row(
              children: [
                Expanded(child: LabelLargeText(title, color: theme.primary20)),
                if (isSelected)
                  Icon(Icons.check_circle, color: theme.primary40, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
