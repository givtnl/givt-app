import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/widgets.dart';

class OutlinedTextFormField extends StatelessWidget {
  const OutlinedTextFormField({
    required this.controller,
    required this.hintText,
    this.errorStyle,
    this.keyboardType,
    this.readOnly = false,
    this.autofillHints = const [],
    this.inputFormatters,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.onTapOutside,
    this.focusNode,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final TextStyle? errorStyle;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool obscureText;
  final TextInputAction textInputAction;
  final IconButton? suffixIcon;
  final List<String> autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final void Function(PointerDownEvent)? onTapOutside;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: primaryFocus,
      onChanged: onChanged,
      style:
          const FamilyAppTheme().toThemeData().textTheme.labelLarge?.copyWith(
                color: FamilyAppTheme.primary40,
              ),
      decoration: InputDecoration(
        hintText: hintText,
        border: enabledInputBorder,
        enabledBorder: enabledInputBorder,
        focusedBorder: selectedInputBorder,
        errorBorder: errorInputBorder,
        suffixIcon: suffixIcon,
        errorStyle: errorStyle,
      ),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      readOnly: readOnly,
      autocorrect: false,
      validator: validator,
      obscureText: obscureText,
      obscuringCharacter: '*',
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onTapOutside: onTapOutside,
    );
  }
}
