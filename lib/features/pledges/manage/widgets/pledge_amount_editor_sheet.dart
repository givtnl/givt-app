import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/constants/donation_amount_constants.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/pledges/manage/cubit/pledge_manage_cubit.dart';
import 'package:givt_app/features/pledges/manage/utils/pledge_amount_validation.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/donation_amount_validation.dart';
import 'package:givt_app/utils/util.dart';

class PledgeAmountEditorSheet {
  const PledgeAmountEditorSheet._();

  static Future<void> show(
    BuildContext context, {
    required PledgeManageCubit cubit,
    required PledgeManageUIModel uiModel,
    required PledgeGoal goal,
  }) {
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
          goal: goal,
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
    required this.goal,
    required this.onClose,
  });

  final PledgeManageCubit cubit;
  final PledgeManageUIModel uiModel;
  final PledgeGoal goal;
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
    _initialAmountInput =
        Util.formatNumberComma(widget.goal.amount, _country);
    _amountController = TextEditingController(text: _initialAmountInput);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String? _amountErrorText() {
    final locals = context.l10n;
    if (DonationAmountValidation.exceedsMaxInputAmount(_amountController.text)) {
      final formattedMax = Util.formatNumberComma(
        DonationAmountConstants.maxInputAmount,
        _country,
      );
      return locals.donationAmountExceedsMaximum(formattedMax);
    }

    final parsed = DonationAmountValidation.parseAmount(_amountController.text);
    if (parsed != null &&
        parsed <= widget.goal.amount &&
        _amountController.text.trim() != _initialAmountInput.trim()) {
      return locals.pledgesEditValidationIncreaseOnly;
    }

    return null;
  }

  bool get _canSave => PledgeAmountValidation.canSave(
        currentAmount: widget.goal.amount,
        input: _amountController.text,
        initialInput: _initialAmountInput,
      );

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final currency =
        Util.getCurrencySymbol(countryCode: context.read<AuthCubit>().state.user.country);

    return FunBottomSheet(
      title: locals.pledgesEditTitle,
      closeAction: widget.onClose,
      content: FunInput(
        label: locals.pledgesEditAmountLabel,
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
        errorText: _amountErrorText(),
        onChanged: (_) => setState(() {}),
      ),
      primaryButton: FunButton(
        text: locals.pledgesEditSaveButton,
        isDisabled: !_canSave,
        isLoading: widget.uiModel.isSaving,
        analyticsEvent:
            AnalyticsEventName.pledgesEditAmountSaveClicked.toEvent(),
        onTap: _canSave && !widget.uiModel.isSaving
            ? () async {
                final amount = DonationAmountValidation.parseAmount(
                  _amountController.text,
                );
                if (amount == null) {
                  return;
                }
                widget.onClose();
                await widget.cubit.saveGoalAmount(
                  goal: widget.goal,
                  amount: amount,
                );
              }
            : null,
      ),
    );
  }
}
