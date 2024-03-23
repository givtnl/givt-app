import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

class CollectionFormField extends StatefulWidget {
  const CollectionFormField({
    required this.isVisible,
    required this.controller,
    required this.amountLimit,
    required this.onRemoveIconPressed,
    required this.onFocused,
    required this.focusNode,
    this.lowerLimit = 0,
    this.isSuffixTextVisible = true,
    this.suffixText = '',
    this.prefixCurrencyIcon = const Icon(
      Icons.euro,
      color: AppTheme.givtLightPurple,
    ),
    this.bottomBorderColor = AppTheme.givtLightGreen,
    this.textColor = AppTheme.givtDarkerGray,
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
  final bool isVisible;
  final Color textColor;

  @override
  State<CollectionFormField> createState() => _CollectionFormFieldState();
}

class _CollectionFormFieldState extends State<CollectionFormField> {
  bool _isTapped = false;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(5),
          child: TextFormField(
            focusNode: widget.focusNode,
            readOnly: true,
            autofocus: true,
            controller: widget.controller,
            onTap: () {
              setState(() {
                _isTapped = true;
              });

              Future.delayed(const Duration(milliseconds: 150), () {
                setState(() {
                  _isTapped = false;
                });
              });
              widget.onFocused(); // Call the onTap callback
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              final currentValue = double.parse(value.replaceAll(',', '.'));
              if (currentValue == 0) {
                return null;
              }

              /// Dart accepts only dot as decimal separator
              if (currentValue > double.parse(widget.amountLimit.toString())) {
                return '';
              }
              if (currentValue < widget.lowerLimit) {
                return '';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: MediaQuery.sizeOf(context).height < 600 ? null : 28,
                  color: _isTapped
                      ? widget.textColor.withOpacity(0.40)
                      : widget.textColor,
                ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              suffixText: widget.isSuffixTextVisible ? widget.suffixText : null,
              suffixStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.textColor,
                  ),
              suffixIcon: IconButton(
                onPressed: widget.isRemoveIconVisible
                    ? widget.onRemoveIconPressed
                    : null,
                icon: Icon(
                  Icons.remove_circle,
                  color: widget.isRemoveIconVisible
                      ? Colors.grey
                      : Colors.transparent,
                ),
              ),
              prefixIcon: widget.prefixCurrencyIcon,
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
                  color: widget.bottomBorderColor,
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
      ),
    );
  }
}
