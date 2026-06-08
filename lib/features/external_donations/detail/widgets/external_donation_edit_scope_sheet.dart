import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/external_donations/detail/cubit/external_donation_detail_cubit.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_manage_field.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_update_scope.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

class ExternalDonationEditScopeSheet {
  const ExternalDonationEditScopeSheet._();

  static Future<void> show(
    BuildContext context, {
    required ExternalDonationDetailCubit cubit,
    required ExternalDonationManageField field,
  }) {
    final locals = context.l10n;
    var selectedScope = ExternalDonationUpdateScope.all;

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
              title: locals.externalDonationsScopeTitle,
              closeAction: () => Navigator.of(sheetContext).pop(),
              content: Column(
                children: [
                  _ScopeOption(
                    title: locals.externalDonationsScopeAll,
                    isSelected:
                        selectedScope == ExternalDonationUpdateScope.all,
                    onTap: () => setState(
                      () => selectedScope = ExternalDonationUpdateScope.all,
                    ),
                  ),
                  _ScopeOption(
                    title: locals.externalDonationsScopeOnwards,
                    isSelected:
                        selectedScope == ExternalDonationUpdateScope.onwards,
                    onTap: () => setState(
                      () =>
                          selectedScope = ExternalDonationUpdateScope.onwards,
                    ),
                  ),
                ],
              ),
              primaryButton: FunButton(
                text: locals.externalDonationsScopeContinue,
                analyticsEvent:
                    AnalyticsEventName.externalDonationsScopeContinueClicked
                        .toEvent(),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  cubit.onScopeSelected(
                    field: field,
                    scope: selectedScope,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _ScopeOption extends StatelessWidget {
  const _ScopeOption({
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
