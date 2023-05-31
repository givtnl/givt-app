import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

class CollectionFormField extends StatelessWidget {
  const CollectionFormField({
    required this.controller,
    required this.amountLimit,
    required this.onRemoveIconPressed,
    required this.onFocused,
    this.isSuffixTextVisible = true,
    this.suffixText = '',
    this.prefixCurrencyIcon = const Icon(
      Icons.euro,
      color: Colors.grey,
    ),
    this.bottomBorderColor = AppTheme.givtLightGreen,
    this.isRemoveIconVisible = false,
    super.key,
  });

  final TextEditingController controller;
  final bool isRemoveIconVisible;
  final bool isSuffixTextVisible;
  final int amountLimit;
  final String suffixText;
  final Icon prefixCurrencyIcon;
  final Color bottomBorderColor;
  final VoidCallback onRemoveIconPressed;
  final VoidCallback onFocused;

  @override
  Widget build(BuildContext context) {
    // final controller = TextEditingController(text: initialValue);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2.5),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          readOnly: true,
          autofocus: true,
          controller: controller,
          onTap: onFocused,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }

            /// Dart accepts only dot as decimal separator
            if (double.parse(value.replaceAll(',', '.')) >
                double.parse(amountLimit.toString())) {
              return '';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 30,
                color: AppTheme.givtDarkerGray,
              ),
          decoration: InputDecoration(
            suffixText: isSuffixTextVisible ? suffixText : null,
            suffixStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.givtDarkerGray,
                ),
            suffixIcon: IconButton(
              onPressed: onRemoveIconPressed,
              icon: Icon(
                Icons.remove_circle,
                color: isRemoveIconVisible ? Colors.grey : Colors.transparent,
              ),
            ),
            prefixIcon: prefixCurrencyIcon,
            errorStyle: const TextStyle(
              height: 0,
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: Colors.red,
                width: 8,
              ),
            ),
            errorBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: Colors.red,
                width: 8,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: bottomBorderColor,
                width: 8,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
