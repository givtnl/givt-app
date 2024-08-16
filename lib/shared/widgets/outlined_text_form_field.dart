import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/widgets.dart';

class OutlinedTextFormField extends StatelessWidget {
  const OutlinedTextFormField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.readOnly = false,
    this.autofillHints = const [],
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool obscureText;
  final TextInputAction textInputAction;
  final IconButton? suffixIcon;
  final List<String> autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: FamilyAppTheme().toThemeData().textTheme.labelLarge?.copyWith(
            color: const Color.fromRGBO(0, 109, 66, 1),
          ),
      decoration: InputDecoration(
        hintText: hintText,
        border: enabledInputBorder,
        enabledBorder: enabledInputBorder,
        focusedBorder: selectedInputBorder,
        errorBorder: errorInputBorder,
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      readOnly: readOnly,
      autocorrect: false,
      validator: validator,
      obscureText: obscureText,
      textInputAction: textInputAction,
    );
  }
}
