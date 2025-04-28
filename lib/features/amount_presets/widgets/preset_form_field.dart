import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
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
    return TextFormField(
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
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        suffixIcon: const Icon(
          FontAwesomeIcons.penToSquare,
          color: FamilyAppTheme.primary30,
          size: 20,
        ),
        labelText: errorMessage,
        labelStyle: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 14,
          color: errorMessage != null
              ? FamilyAppTheme.error50
              : FamilyAppTheme.primary30,
        ),
        errorStyle: const TextStyle(
          height: 0,
        ),
        focusedErrorBorder: _buildErrorBorder(),
        errorBorder: _buildErrorBorder(),
        focusedBorder: _buildFocusedBorder(),
        enabledBorder: _buildEnabledBorder(),
      ),
    );
  }

  OutlineInputBorder _buildErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: FamilyAppTheme.error50,
        width: 2,
      ),
    );
  }

  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: FamilyAppTheme.primary30,
        width: 2,
      ),
    );
  }

  OutlineInputBorder _buildEnabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: FamilyAppTheme.neutral95,
        width: 1,
      ),
    );
  }
}
