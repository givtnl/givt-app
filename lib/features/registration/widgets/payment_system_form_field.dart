import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/shared/widgets/sort_code_text_formatter.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';
import 'package:iban/iban.dart';

typedef OnPaymentChanged = void Function(int selected);
typedef OnFieldChanged = void Function(String value);

class PaymentSystemTab extends StatefulWidget {
  const PaymentSystemTab({
    required this.bankAccount,
    required this.ibanNumber,
    required this.sortCode,
    required this.onPaymentChanged,
    required this.onFieldChanged,
    required this.isUK,
    this.bankAccountFocus,
    this.ibanNumberFocus,
    this.sortCodeFocus,
    super.key,
  });

  final TextEditingController bankAccount;
  final TextEditingController ibanNumber;
  final TextEditingController sortCode;
  final OnPaymentChanged onPaymentChanged;
  final OnFieldChanged onFieldChanged;
  final bool isUK;
  final FocusNode? bankAccountFocus;
  final FocusNode? ibanNumberFocus;
  final FocusNode? sortCodeFocus;

  @override
  State<PaymentSystemTab> createState() => _PaymentSystemTabState();
}

class _PaymentSystemTabState extends State<PaymentSystemTab> {
  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Column(
      children: [
        if (!widget.isUK)
          const Icon(
            Icons.euro,
            color: AppTheme.givtBlue,
            size: 20,
          ),
        if (widget.isUK)
          const Icon(
            Icons.currency_pound_rounded,
            color: AppTheme.givtBlue,
            size: 20,
          ),
        const SizedBox(height: 16),
        Visibility(
          visible: !widget.isUK,
          child: _buildTextFormField(
            hintText: locals.ibanPlaceHolder,
            controller: widget.ibanNumber,
            focusNode: widget.ibanNumberFocus,
            keyboardType: TextInputType.text,
            onChanged: (value) => widget.onFieldChanged(value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              if (!isValid(value)) {
                return '';
              }
              return null;
            },
          ),
        ),
        Visibility(
          visible: widget.isUK,
          child: Column(
            children: [
              _buildTextFormField(
                hintText: locals.sortCodePlaceholder,
                controller: widget.sortCode,
                focusNode: widget.sortCodeFocus,
                onChanged: (value) => widget.onFieldChanged(value),
                inputFormatters: [SortCodeTextFormatter()],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  if (!Util.ukSortCodeRegEx.hasMatch(value)) {
                    return '';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                hintText: locals.bankAccountNumberPlaceholder,
                controller: widget.bankAccount,
                focusNode: widget.bankAccountFocus,
                onChanged: (value) => widget.onFieldChanged(value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  if (value.length != 8) {
                    return '';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required void Function(String) onChanged,
    FocusNode? focusNode,
    TextInputType? keyboardType = TextInputType.number,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return OutlinedTextFormField(
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.words,
      scrollPadding: const EdgeInsets.only(bottom: 150),
      inputFormatters: inputFormatters,
    );
  }
}
