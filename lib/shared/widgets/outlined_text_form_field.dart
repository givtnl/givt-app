import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/widgets.dart';

class OutlinedTextFormField extends StatelessWidget {
  const OutlinedTextFormField({
    this.hintText,
    this.controller,
    this.minLines,
    this.maxLines = 1,
    this.errorMaxLines = 1,
    this.initialValue = '', // Only when controller is null
    this.errorStyle,
    this.keyboardType,
    this.readOnly = false,
    this.enabled = true,
    this.autofillHints = const [],
    this.inputFormatters,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.prefixText,
    this.onChanged,
    this.focusNode,
    this.validator,
    this.onTapOutside,
    this.smallFont = false,
    this.scrollPadding = const EdgeInsets.all(20),
    super.key,
  });

  final TextEditingController? controller;
  final int? minLines;
  final int? maxLines;
  final int? errorMaxLines;
  final String initialValue;
  final String? hintText;
  final TextStyle? errorStyle;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final TextInputAction textInputAction;
  final IconButton? suffixIcon;
  final String? prefixText;
  final List<String> autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final void Function(PointerDownEvent)? onTapOutside;
  final bool smallFont;
  final EdgeInsets scrollPadding;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      onChanged: onChanged,
      scrollPadding: scrollPadding,
      style: smallFont
          ? const FamilyAppTheme().toThemeData().textTheme.bodySmall?.copyWith(
              color: FamilyAppTheme.primary20,
            )
          : const FamilyAppTheme().toThemeData().textTheme.labelLarge?.copyWith(
              color: FamilyAppTheme.primary20,
            ),
      decoration: InputDecoration(
        hintText: hintText,
        border: enabledInputBorder,
        enabledBorder: enabledInputBorder,
        focusedBorder: selectedInputBorder,
        errorBorder: errorInputBorder,
        suffixIcon: suffixIcon,
        prefix: prefixText != null
            ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: LabelLargeText(
                  prefixText!,
                  color: FamilyAppTheme.primary20,
                ),
              )
            : null,
        errorStyle: errorStyle,
        errorMaxLines: errorMaxLines,
      ),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      readOnly: readOnly,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
      autocorrect: false,
      validator: validator,
      obscureText: obscureText,
      obscuringCharacter: '*',
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onTapOutside: onTapOutside,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
