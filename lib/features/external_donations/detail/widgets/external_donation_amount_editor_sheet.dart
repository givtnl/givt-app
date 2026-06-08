import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/constants/donation_amount_constants.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/external_donations/detail/cubit/external_donation_detail_cubit.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_update_scope.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_display.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/donation_amount_validation.dart';
import 'package:givt_app/utils/util.dart';

class ExternalDonationAmountEditorSheet {
  const ExternalDonationAmountEditorSheet._();

  static double _initialAmountValue(ExternalDonationDetailUIModel uiModel) {
    if (!uiModel.isSelectionMode || uiModel.selectedTransactionIds.isEmpty) {
      return uiModel.donation.amount;
    }

    final selected = uiModel.history.where(
      (item) =>
          item.transactionId != null &&
          uiModel.selectedTransactionIds.contains(item.transactionId),
    );
    return selected.firstOrNull?.amount ?? uiModel.donation.amount;
  }

  static Future<void> show(
    BuildContext context, {
    required ExternalDonationDetailCubit cubit,
    required ExternalDonationDetailUIModel uiModel,
    ExternalDonationUpdateScope? scope,
    required bool isBulk,
  }) {
    final initialAmount = isBulk
        ? _initialAmountValue(uiModel)
        : uiModel.donation.amount;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return _AmountEditorContent(
          cubit: cubit,
          uiModel: uiModel,
          scope: scope,
          isBulk: isBulk,
          initialAmount: initialAmount,
          onClose: () => Navigator.of(sheetContext).pop(),
        );
      },
    );
  }
}

class _AmountEditorContent extends StatefulWidget {
  const _AmountEditorContent({
    required this.cubit,
    required this.uiModel,
    required this.scope,
    required this.isBulk,
    required this.initialAmount,
    required this.onClose,
  });

  final ExternalDonationDetailCubit cubit;
  final ExternalDonationDetailUIModel uiModel;
  final ExternalDonationUpdateScope? scope;
  final bool isBulk;
  final double initialAmount;
  final VoidCallback onClose;

  @override
  State<_AmountEditorContent> createState() => _AmountEditorContentState();
}

class _AmountEditorContentState extends State<_AmountEditorContent> {
  late final TextEditingController _amountController;
  late final String _initialAmountInput;
  late final Country _country;

  @override
  void initState() {
    super.initState();
    _country = Country.fromCode(
      context.read<AuthCubit>().state.user.country,
    );
    _initialAmountInput = Util.formatNumberComma(widget.initialAmount, _country);
    _amountController = TextEditingController(text: _initialAmountInput);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String? _amountErrorText(AppLocalizations locals) {
    if (!DonationAmountValidation.exceedsMaxInputAmount(_amountController.text)) {
      return null;
    }
    final formattedMax = Util.formatNumberComma(
      DonationAmountConstants.maxInputAmount,
      _country,
    );
    return locals.donationAmountExceedsMaximum(formattedMax);
  }

  bool get _canSave {
    if (!DonationAmountValidation.isPositiveWithinInputLimit(
      _amountController.text,
    )) {
      return false;
    }
    return _amountController.text.trim() != _initialAmountInput.trim();
  }

  String _infoText(
    AppLocalizations locals,
    String currency,
    String locale,
    double amount,
  ) {
    if (widget.isBulk) {
      return locals.externalDonationsEditAmountBulkInfo;
    }
    final formattedAmount =
        '$currency${Util.formatNumberComma(amount, _country)}';
    final donation = widget.uiModel.donation;
    if (donation.isOneOff || widget.scope == null) {
      return locals.externalDonationsEditAmountInfoOneOff(formattedAmount);
    }
    final nextDate = donation.nextRecurringOccurrenceDate ??
        donation.startDateTime ??
        DateTime.now();
    final formattedDate =
        ExternalDonationDisplay.formatDate(nextDate, locale);
    return switch (widget.scope!) {
      ExternalDonationUpdateScope.all =>
        locals.externalDonationsEditAmountInfoAll(formattedAmount),
      ExternalDonationUpdateScope.onwards =>
        locals.externalDonationsEditAmountInfoOnwards(
          formattedDate,
          formattedAmount,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final auth = context.read<AuthCubit>().state;
    final currency = Util.getCurrencySymbol(countryCode: auth.user.country);
    final locale = Util.getLanguageTageFromLocale(context);
    final parsedAmount =
        DonationAmountValidation.parseAmount(_amountController.text) ??
            widget.initialAmount;

    return FunBottomSheet(
      title: locals.externalDonationsManageAmount,
      closeAction: widget.onClose,
      content: Column(
        children: [
          FunInput(
            label: locals.externalDonationsManageAmount,
            controller: _amountController,
            hintText: locals.recurringDonationsCreateStep2AmountHint,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                Util.numberInputFieldRegExp(),
              ),
              LengthLimitingTextInputFormatter(
                DonationAmountConstants.maxIntegerDigits + 3,
              ),
            ],
            prefixText: currency,
            errorText: _amountErrorText(locals),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          BodySmallText(
            _infoText(locals, currency, locale, parsedAmount),
            color: FamilyAppTheme.neutral50,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      primaryButton: FunButton(
        text: locals.externalDonationsSave,
        isDisabled: !_canSave,
        isLoading: widget.uiModel.isSaving,
        analyticsEvent:
            AnalyticsEventName.externalDonationsEditAmountSaveClicked.toEvent(),
        onTap: _canSave && !widget.uiModel.isSaving
            ? () async {
                final amount = DonationAmountValidation.parseAmount(
                  _amountController.text,
                );
                if (amount == null) {
                  return;
                }
                widget.onClose();
                await widget.cubit.saveAmount(
                  amount: amount,
                  scope: widget.scope,
                  isBulk: widget.isBulk,
                );
              }
            : null,
      ),
    );
  }
}
