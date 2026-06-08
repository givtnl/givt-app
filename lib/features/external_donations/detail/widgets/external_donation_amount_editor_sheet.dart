import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/external_donations/detail/cubit/external_donation_detail_cubit.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_update_scope.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_display.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExternalDonationAmountEditorSheet {
  const ExternalDonationAmountEditorSheet._();

  static double _initialBulkAmount(ExternalDonationDetailUIModel uiModel) {
    final selected = uiModel.history.where(
      (item) =>
          item.transactionId != null &&
          uiModel.selectedTransactionIds.contains(item.transactionId),
    );
    final firstSelected = selected.firstOrNull;
    return firstSelected?.amount ?? uiModel.donation.amount;
  }

  static Future<void> show(
    BuildContext context, {
    required ExternalDonationDetailCubit cubit,
    required ExternalDonationDetailUIModel uiModel,
    ExternalDonationUpdateScope? scope,
    required bool isBulk,
  }) {
    final locals = context.l10n;
    final auth = context.read<AuthCubit>().state;
    final currency = Util.getCurrencySymbol(countryCode: auth.user.country);
    final country = Country.fromCode(auth.user.country);
    final locale = Util.getLanguageTageFromLocale(context);
    final donation = uiModel.donation;
    final initialAmount = isBulk
        ? _initialBulkAmount(uiModel).round()
        : donation.amount.round();
    var currentAmount = initialAmount;

    String infoText() {
      if (isBulk) {
        return locals.externalDonationsEditAmountBulkInfo;
      }
      final formattedAmount =
          '$currency${Util.formatNumberComma(currentAmount.toDouble(), country)}';
      if (donation.isOneOff || scope == null) {
        return locals.externalDonationsEditAmountInfoOneOff(formattedAmount);
      }
      final nextDate = donation.nextRecurringOccurrenceDate ??
          donation.startDateTime ??
          DateTime.now();
      final formattedDate =
          ExternalDonationDisplay.formatDate(nextDate, locale);
      return switch (scope) {
        ExternalDonationUpdateScope.all =>
          locals.externalDonationsEditAmountInfoAll(formattedAmount),
        ExternalDonationUpdateScope.onwards =>
          locals.externalDonationsEditAmountInfoOnwards(
            formattedDate,
            formattedAmount,
          ),
      };
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
            final hasChanged = currentAmount != initialAmount;
            final canSave = hasChanged && currentAmount > 0;

            return FunBottomSheet(
              title: locals.externalDonationsManageAmount,
              closeAction: () => Navigator.of(sheetContext).pop(),
              content: Column(
                children: [
                  FunCounter(
                    prefix: currency,
                    initialAmount: initialAmount,
                    minAmount: 1,
                    onAmountChanged: (amount) {
                      setState(() => currentAmount = amount);
                    },
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
                isDisabled: !canSave,
                isLoading: uiModel.isSaving,
                analyticsEvent:
                    AnalyticsEventName.externalDonationsEditAmountSaveClicked
                        .toEvent(),
                onTap: canSave && !uiModel.isSaving
                    ? () async {
                        Navigator.of(sheetContext).pop();
                        await cubit.saveAmount(
                          amount: currentAmount.toDouble(),
                          scope: scope,
                          isBulk: isBulk,
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
