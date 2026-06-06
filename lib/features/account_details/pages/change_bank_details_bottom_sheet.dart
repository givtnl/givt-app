import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/account_details/widgets/personal_info_edit_sheet_success.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/sort_code_text_formatter.dart';
import 'package:givt_app/utils/util.dart';
import 'package:iban/iban.dart';

class ChangeBankDetailsBottomSheet extends StatefulWidget {
  const ChangeBankDetailsBottomSheet({
    required this.iban,
    required this.accountNumber,
    required this.sortCode,
    super.key,
  });

  final String iban;
  final String accountNumber;
  final String sortCode;

  @override
  State<ChangeBankDetailsBottomSheet> createState() =>
      _ChangeBankDetailsBottomSheetState();
}

class _ChangeBankDetailsBottomSheetState
    extends State<ChangeBankDetailsBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController ibanController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController sortCodeController = TextEditingController();

  bool get _isSepa => widget.iban.isNotEmpty;

  @override
  void initState() {
    ibanController.text = widget.iban;
    accountNumberController.text = widget.accountNumber;
    sortCodeController.text = SortCodeTextFormatter.formatForDisplay(
      widget.sortCode,
    );
    super.initState();
  }

  @override
  void dispose() {
    ibanController.dispose();
    accountNumberController.dispose();
    sortCodeController.dispose();
    super.dispose();
  }

  String get _submittedSortCode => SortCodeTextFormatter.stripDashes(
        sortCodeController.text,
      );

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BlocBuilder<PersonalInfoEditBloc, PersonalInfoEditState>(
      builder: (context, state) {
        final isLoading = state.status == PersonalInfoEditStatus.loading;
        final isSuccess = state.status == PersonalInfoEditStatus.success;

        if (isSuccess) {
          return FunBottomSheet(
            closeAction: () => completePersonalInfoEditSheet(context),
            title: locals.success,
            content: FunIcon.checkmark(),
            primaryButton: FunButton(
              text: locals.buttonDone,
              onTap: () => completePersonalInfoEditSheet(context),
              analyticsEvent: AnalyticsEvent(
                AnalyticsEventName.editBankDetailsSaveClicked,
              ),
            ),
          );
        }

        return FunBottomSheet(
          closeAction: () => Navigator.of(context).pop(),
          title: _isSepa ? locals.editIbanAccount : locals.changeBankAccountNumberAndSortCode,
          content: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                if (_isSepa)
                  InputFormField(
                    controller: ibanController,
                    hintText: locals.ibanPlaceHolder,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      if (value == null || value.isEmpty || !isValid(value)) {
                        return '';
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  )
                else ...[
                  InputFormField(
                    controller: sortCodeController,
                    label: locals.sortCodePlaceholder,
                    hintText: locals.sortCodePlaceholder,
                    inputFormatters: [SortCodeTextFormatter()],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return locals.fieldRequired;
                      }
                      if (!Util.ukSortCodeRegEx.hasMatch(value)) {
                        return locals.sortCodeMustBe6Digits;
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  InputFormField(
                    controller: accountNumberController,
                    label: locals.bankAccountNumberPlaceholder,
                    hintText: locals.bankAccountNumberPlaceholder,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length != 8) {
                        return '';
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ],
            ),
          ),
          primaryButton: FunButton(
            isDisabled: !isEnabled || isLoading,
            onTap: isEnabled && !isLoading ? _onSave : null,
            text: isLoading ? locals.loadingTitle : locals.save,
            analyticsEvent: AnalyticsEvent(
              AnalyticsEventName.editBankDetailsSaveClicked,
            ),
          ),
        );
      },
    );
  }

  void _onSave() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    context.read<PersonalInfoEditBloc>().add(
          PersonalInfoEditBankDetails(
            iban: ibanController.text.replaceAll(' ', ''),
            accountNumber: accountNumberController.text,
            sortCode: _submittedSortCode,
          ),
        );
  }

  bool get isEnabled {
    if (formKey.currentState == null) return false;
    if (!formKey.currentState!.validate()) return false;

    if (_isSepa) {
      final cleanedIban = ibanController.text.replaceAll(' ', '');
      return cleanedIban != widget.iban.replaceAll(' ', '');
    }

    return accountNumberController.text != widget.accountNumber ||
        _submittedSortCode != widget.sortCode;
  }
}
