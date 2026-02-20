import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/utils.dart';
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
    this.borderColor = AppTheme.givtLightGreen,
    this.textColor = AppTheme.givtDarkerGray,
    this.isRemoveIconVisible = false,
    this.isSelected = false,
    super.key,
  });

  final TextEditingController controller;
  final bool isRemoveIconVisible;
  final bool isSuffixTextVisible;
  final int amountLimit;
  final double lowerLimit;
  final String suffixText;
  final Icon prefixCurrencyIcon;
  final Color borderColor;
  final VoidCallback onRemoveIconPressed;
  final VoidCallback onFocused;
  final FocusNode focusNode;
  final bool isVisible;
  final Color textColor;
  final bool isSelected;

  @override
  State<CollectionFormField> createState() => _CollectionFormFieldState();
}

String? _validateCollectionValue(
  String? value, {
  required int amountLimit,
  required double lowerLimit,
}) {
  if (value == null || value.isEmpty) {
    return '';
  }
  final currentValue = double.parse(
    value.replaceAll(',', '.'),
  );
  if (currentValue == 0) {
    return null;
  }
  if (currentValue > double.parse(amountLimit.toString())) {
    return '';
  }
  if (currentValue < lowerLimit) {
    return '';
  }
  return null;
}

class _CollectionFormFieldState extends State<CollectionFormField> {
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(CollectionFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const radius = 12.0;
    final theme = FunTheme.of(context);
    final thinWidth = theme.borderWidthThin;

    return Visibility(
      visible: widget.isVisible,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: FormField<String>(
          initialValue: widget.controller.text,
          validator: (value) => _validateCollectionValue(
            value,
            amountLimit: widget.amountLimit,
            lowerLimit: widget.lowerLimit,
          ),
          builder: (state) {
            final ctrlText = widget.controller.text;
            final needSync = state.value != ctrlText;
            if (needSync) {
              final controllerRef = widget.controller;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                state.didChange(controllerRef.text);
              });
            }
            final bool showError =
                _validateCollectionValue(
                  ctrlText,
                  amountLimit: widget.amountLimit,
                  lowerLimit: widget.lowerLimit,
                ) !=
                null;
            final borderColor =
                showError ? theme.error50 : widget.borderColor;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: Border(
                  left: BorderSide(width: 10, color: borderColor),
                  top: BorderSide(width: thinWidth, color: borderColor),
                  right: BorderSide(width: thinWidth, color: borderColor),
                  bottom: BorderSide(width: thinWidth, color: borderColor),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Material(
                borderRadius: BorderRadius.circular(radius),
                child: TextFormField(
                  focusNode: widget.focusNode,
                  readOnly: true,
                  autofocus: true,
                  controller: widget.controller,
                  onTap: () {
                    setState(() {
                      _isTapped = true;
                    });

                    Future.delayed(const Duration(milliseconds: 10), () {
                      setState(() {
                        _isTapped = false;
                      });
                    });
                    widget.onFocused();
                  },
                  textInputAction: TextInputAction.next,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: MediaQuery.sizeOf(context).height < 600
                        ? null
                        : 28,
                    color: _isTapped
                        ? widget.textColor.withValues(alpha: 0.40)
                        : widget.textColor,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    suffixText: widget.isSuffixTextVisible
                        ? widget.suffixText
                        : null,
                    suffixStyle: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(
                          color: widget.textColor,
                        ),
                    suffixIcon: IconButton(
                      onPressed: widget.isRemoveIconVisible
                          ? widget.onRemoveIconPressed
                          : null,
                      icon: Icon(
                        Icons.remove_circle,
                        color: widget.isRemoveIconVisible
                            ? widget.textColor
                            : Colors.transparent,
                      ),
                    ),
                    prefixIcon: widget.prefixCurrencyIcon,
                    errorStyle: const TextStyle(
                      height: 0.01,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
