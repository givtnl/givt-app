import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/color_schemes.g.dart';

class FamilyTextFormField extends StatelessWidget {
  const FamilyTextFormField({
    required this.controller,
    this.hintText,
    super.key,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.suffixIcon,
    this.readOnly = false,
    this.inputFormatters = const [],
    this.autofillHints,
    this.autocorrect = true,
    this.focusNode,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool readOnly;
  final List<TextInputFormatter> inputFormatters;
  final Iterable<String>? autofillHints;
  final bool autocorrect;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        readOnly: readOnly,
        enabled: !readOnly,
        controller: controller,
        validator: validator,
        autofillHints: autofillHints,
        autocorrect: autocorrect,
        onChanged: onChanged,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        focusNode: focusNode,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              color:
                  readOnly ? AppTheme.givtDarkerGray : lightColorScheme.primary,
            ),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isCollapsed: true,
          hintText: hintText,
          labelText: hintText,
          suffixIcon: suffixIcon,
          errorMaxLines: 2,
          labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                color: AppTheme.givtDarkerGray,
              ),
          contentPadding: const EdgeInsets.only(left: 10, bottom: 15, top: 15),
          errorStyle: const TextStyle(
            height: 0,
          ),
        ),
      ),
    );
  }
}
