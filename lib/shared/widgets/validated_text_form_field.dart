import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/app_theme.dart';

/// A text form field that only shows validation errors after the user
/// has interacted with the field and then left it (onBlur behavior).
class ValidatedTextFormField extends StatefulWidget {
  const ValidatedTextFormField({
    this.hintText,
    this.controller,
    this.minLines,
    this.maxLines = 1,
    this.errorMaxLines = 2,
    this.initialValue = '',
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
  State<ValidatedTextFormField> createState() => _ValidatedTextFormFieldState();
}

class _ValidatedTextFormFieldState extends State<ValidatedTextFormField> {
  late FocusNode _focusNode;
  bool _hasBeenBlurred = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && !_hasBeenBlurred) {
      setState(() {
        _hasBeenBlurred = true;
        _validateField();
      });
    } else if (_hasBeenBlurred) {
      _validateField();
    }
  }

  void _validateField() {
    final value = widget.controller?.text ?? widget.initialValue;
    final error = widget.validator?.call(value);
    if (_errorText != error) {
      setState(() {
        _errorText = error;
      });
    }
  }

  void _onChanged(String value) {
    widget.onChanged?.call(value);
    if (_hasBeenBlurred) {
      _validateField();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      controller: widget.controller,
      initialValue: widget.controller == null ? widget.initialValue : null,
      onChanged: _onChanged,
      scrollPadding: widget.scrollPadding,
      style: widget.smallFont
          ? const FamilyAppTheme()
              .toThemeData()
              .textTheme
              .bodySmall
              ?.copyWith(color: FunTheme.of(context).primary20)
          : const FamilyAppTheme()
              .toThemeData()
              .textTheme
              .labelLarge
              ?.copyWith(color: FunTheme.of(context).primary20),
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: enabledInputBorder,
        enabledBorder:
            _hasBeenBlurred && _errorText != null && _errorText!.isNotEmpty
                ? errorInputBorder
                : enabledInputBorder,
        focusedBorder:
            _hasBeenBlurred && _errorText != null && _errorText!.isNotEmpty
                ? focusedErrorInputBorder
                : selectedInputBorder,
        errorBorder: errorInputBorder,
        focusedErrorBorder: focusedErrorInputBorder,
        suffixIcon: widget.suffixIcon,
        prefix: widget.prefixText != null
            ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: LabelLargeText(
                  widget.prefixText!,
                  color: FunTheme.of(context).primary20,
                ),
              )
            : null,
        errorText:
            _hasBeenBlurred && _errorText != null && _errorText!.isNotEmpty
                ? _errorText
                : null,
        errorStyle: const TextStyle(color: AppTheme.error50, fontSize: 12),
        errorMaxLines: widget.errorMaxLines,
      ),
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      autofillHints: widget.autofillHints,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      autocorrect: false,
      validator: (value) {
        if (!_hasBeenBlurred) return null;
        return widget.validator?.call(value);
      },
      obscureText: widget.obscureText,
      obscuringCharacter: '*',
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      onTapOutside: widget.onTapOutside,
      autovalidateMode: AutovalidateMode.disabled,
    );
  }
}
