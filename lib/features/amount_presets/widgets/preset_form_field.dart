import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
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
        suffixIcon: Icon(
          FontAwesomeIcons.penToSquare,
          color: FunTheme.of(context).primary30,
          size: 20,
        ),
        labelText: errorMessage,
        labelStyle: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 14,
          color: errorMessage != null
              ? FunTheme.of(context).error50
              : FunTheme.of(context).primary30,
        ),
        errorStyle: const TextStyle(
          height: 0,
        ),
        focusedErrorBorder: _buildErrorBorder(context),
        errorBorder: _buildErrorBorder(context),
        focusedBorder: _buildFocusedBorder(context),
        enabledBorder: _buildEnabledBorder(context),
      ),
    );
  }

  OutlineInputBorder _buildErrorBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: FunTheme.of(context).error50,
        width: 2,
      ),
    );
  }

  OutlineInputBorder _buildFocusedBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: FunTheme.of(context).primary30,
        width: 2,
      ),
    );
  }

  OutlineInputBorder _buildEnabledBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: FunTheme.of(context).neutral95,
      ),
    );
  }
}
