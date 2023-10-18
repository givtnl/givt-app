import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/utils/app_theme.dart';

class CreateChildTextField extends StatelessWidget {
  const CreateChildTextField({
    super.key,
    this.labelText,
    this.maxLength,
    this.textInputAction,
    this.keyboardType,
    this.onChanged,
    this.controller,
    this.onTap,
    this.showCursor,
    this.readOnly = false,
    this.inputFormatters,
    this.errorText,
    this.enabled,
  });

  final String? labelText;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final void Function(String value)? onChanged;
  final TextEditingController? controller;
  final void Function()? onTap;
  final bool? showCursor;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      maxLength: maxLength,
      controller: controller,
      onTap: onTap,
      showCursor: showCursor,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(color: AppTheme.sliderIndicatorFilled),
      decoration: InputDecoration(
        label: labelText != null ? Text(labelText!) : null,
        errorText: errorText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppTheme.inputFieldBorderEnabled,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppTheme.inputFieldBorderSelected,
          ),
        ),
      ),
    );
  }
}
