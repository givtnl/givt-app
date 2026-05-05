import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/shared/design_system/components/input/fun_input.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

/// Connects [FunInput] to Flutter’s [Form] via [FormField] (validators, etc.).
///
/// This is **not** a FUN design-system component (no `Fun` prefix): it is app
/// glue. The visual input remains [FunInput].
class InputFormField extends StatelessWidget {
  const InputFormField({
    required this.controller,
    required this.hintText,
    super.key,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.readOnly = false,
    this.prefixIcon,
    this.prefixText,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.analyticsEvent,
    this.heroTag,
    this.label,
    this.enabled = true,
    this.obscureText = false,
    this.suffixIcon,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.scrollPadding = const EdgeInsets.all(20),
    this.errorMaxLines,
    this.minLines,
    this.maxLines,
    this.onTap,
  });

  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool readOnly;
  final Widget? prefixIcon;
  final String? prefixText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final AnalyticsEvent? analyticsEvent;
  final String? heroTag;
  final String? label;
  final bool enabled;
  final bool obscureText;
  final Widget? suffixIcon;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final EdgeInsets scrollPadding;
  final int? errorMaxLines;
  final int? minLines;
  final int? maxLines;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: controller.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      builder: (field) {
        return FunInput(
          controller: controller,
          hintText: hintText,
          errorText: field.errorText,
          onChanged: (value) {
            field.didChange(value);
            onChanged?.call(value);
          },
          onTap: onTap,
          focusNode: focusNode,
          readOnly: readOnly,
          prefixIcon: prefixIcon,
          prefixText: prefixText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction ?? TextInputAction.next,
          analyticsEvent: analyticsEvent,
          heroTag: heroTag,
          label: label,
          enabled: enabled,
          obscureText: obscureText,
          suffixIcon: suffixIcon,
          autofillHints: autofillHints,
          textCapitalization: textCapitalization,
          scrollPadding: scrollPadding,
          errorMaxLines: errorMaxLines,
          minLines: minLines,
          maxLines: maxLines,
        );
      },
    );
  }
}
