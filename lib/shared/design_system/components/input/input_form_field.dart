import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/shared/design_system/components/input/fun_input.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

/// Connects [FunInput] to Flutter’s [Form] via [FormField] (validators, etc.).
///
/// This is **not** a FUN design-system component (no `Fun` prefix): it is app
/// glue. The visual input remains [FunInput].
class InputFormField extends StatefulWidget {
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
    this.maxLines = 1,
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
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_syncFromController);
  }

  @override
  void didUpdateWidget(covariant InputFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_syncFromController);
      widget.controller.addListener(_syncFromController);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncFromController);
    super.dispose();
  }

  /// [TextField.onChanged] does not run when the controller is updated in
  /// code. Keep [FormField] on the same text so validate() sees the suggestion.
  void _syncFromController() {
    final field = _fieldKey.currentState;
    if (field == null || !field.mounted) {
      return;
    }
    final text = widget.controller.text;
    if (field.value == text) {
      return;
    }
    field.didChange(text);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: _fieldKey,
      initialValue: widget.controller.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      builder: (field) {
        return FunInput(
          controller: widget.controller,
          hintText: widget.hintText,
          errorText: field.errorText,
          onChanged: (value) {
            if (field.value != value) {
              field.didChange(value);
            }
            widget.onChanged?.call(value);
          },
          onTap: widget.onTap,
          focusNode: widget.focusNode,
          readOnly: widget.readOnly,
          prefixIcon: widget.prefixIcon,
          prefixText: widget.prefixText,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          analyticsEvent: widget.analyticsEvent,
          heroTag: widget.heroTag,
          label: widget.label,
          enabled: widget.enabled,
          obscureText: widget.obscureText,
          suffixIcon: widget.suffixIcon,
          autofillHints: widget.autofillHints,
          textCapitalization: widget.textCapitalization,
          scrollPadding: widget.scrollPadding,
          errorMaxLines: widget.errorMaxLines,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
        );
      },
    );
  }
}
