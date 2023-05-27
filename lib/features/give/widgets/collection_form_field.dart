import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/utils/app_theme.dart';

class CollectionFormField extends StatelessWidget {
  const CollectionFormField({
    required this.controller,
    required this.amountLimit,
    required this.onRemoveIconPressed,
    required this.onFocused,
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
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
          decoration: InputDecoration(
            suffixText: isRemoveIconVisible ? suffixText : null,
            suffixIcon: isRemoveIconVisible
                ? IconButton(
                    onPressed: onRemoveIconPressed,
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.grey,
                    ),
                  )
                : null,
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
