import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

class CollectionFormField extends StatelessWidget {
  const CollectionFormField({
    required this.controller,
    required this.amountLimit,
    required this.lowerLimit,
    required this.onRemoveIconPressed,
    required this.onFocused,
    required this.focusNode,
    this.isSuffixTextVisible = true,
    this.suffixText = '',
    this.prefixCurrencyIcon = const Icon(
      Icons.euro,
      color: Colors.black26,
    ),
    this.bottomBorderColor = AppTheme.givtLightGreen,
    this.isRemoveIconVisible = false,
    super.key,
  });

  final TextEditingController controller;
  final bool isRemoveIconVisible;
  final bool isSuffixTextVisible;
  final int amountLimit;
  final double lowerLimit;
  final String suffixText;
  final Icon prefixCurrencyIcon;
  final Color bottomBorderColor;
  final VoidCallback onRemoveIconPressed;
  final VoidCallback onFocused;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(5),
        child: TextFormField(
          focusNode: focusNode,
          readOnly: true,
          autofocus: true,
          controller: controller,
          onTap: onFocused,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            final currentValue = double.parse(value.replaceAll(',', '.'));
            if (currentValue == 0) {
              return null;
            }

            /// Dart accepts only dot as decimal separator
            if (currentValue > double.parse(amountLimit.toString())) {
              return '';
            }
            if (currentValue < lowerLimit) {
              return '';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.normal,
                color: AppTheme.givtDarkerGray,
              ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            suffixText: isSuffixTextVisible ? suffixText : null,
            suffixStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.givtDarkerGray,
                ),
            suffixIcon: IconButton(
              onPressed: isRemoveIconVisible ? onRemoveIconPressed : null,
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
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              borderSide: BorderSide(
                color: Colors.red,
                width: 8,
              ),
            ),
            errorBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              borderSide: BorderSide(
                color: Colors.red,
                width: 8,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              borderSide: BorderSide(
                color: bottomBorderColor,
                width: 8,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
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
