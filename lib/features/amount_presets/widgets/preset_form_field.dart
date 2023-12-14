import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class PresetFormField extends StatefulWidget {
  const PresetFormField({
    required this.controller,
    required this.amountLimit,
    required this.lowerLimit,
    required this.currency,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final int amountLimit;
  final String currency;
  final double lowerLimit;
  final void Function(String) onChanged;

  @override
  State<PresetFormField> createState() => _PresetFormFieldState();
}

class _PresetFormFieldState extends State<PresetFormField> {
  String? errorMessage;

  String? validateField({
    required AppLocalizations locals,
    String? value,
  }) {
    if (value == null || value.isEmpty) {
      return locals.amountPresetsErrEmpty;
    }
    final currentValue = double.parse(value.replaceAll(',', '.'));

    /// Dart accepts only dot as decimal separator
    if (currentValue > double.parse(widget.amountLimit.toString())) {
      return locals.amountPresetsErrGivingLimit;
    }
    if (currentValue < widget.lowerLimit) {
      return locals
          .amountPresetsErr25C('${widget.currency} ${widget.lowerLimit}');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(5),
        child: TextFormField(
          controller: widget.controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              Util.numberInputFieldRegExp(),
            ),
          ],
          onChanged: (value) {
            widget.onChanged(value);
            setState(() {
              errorMessage = validateField(
                value: value,
                locals: locals,
              );
            });
          },
          validator: (value) => validateField(
                    value: value,
                    locals: locals,
                  ) !=
                  null
              ? ''
              : null,
          textInputAction: TextInputAction.next,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: AppTheme.givtBlue,
              ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(24),
            suffixStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.givtBlue,
                ),
            suffixIcon: const Icon(
              Icons.edit,
              color: AppTheme.givtBlue,
            ),
            labelText: errorMessage,
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.givtRed,
                ),
            errorStyle: const TextStyle(
              height: 0,
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              borderSide: BorderSide(
                color: Colors.red,
                width: 8,
              ),
            ),
            errorBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              borderSide: BorderSide(
                color: Colors.red,
                width: 8,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              borderSide: BorderSide(
                color: AppTheme.givtLightGreen,
                width: 8,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
