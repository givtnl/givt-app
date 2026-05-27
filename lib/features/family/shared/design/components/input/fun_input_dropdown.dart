import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input_label.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';

class FunInputDropdown<T> extends StatefulWidget {
  const FunInputDropdown({
    required this.items,
    required this.onChanged,
    required this.itemBuilder,
    this.value,
    this.hint,
    this.focusNode,
    this.selectedItemBuilder,
    this.label,
    this.enabled = true,
    this.errorText,
    super.key,
  });

  final List<T> items;
  final T? value;
  final Widget? hint;
  final ValueChanged<T>? onChanged;
  final FocusNode? focusNode;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget Function(BuildContext, T)? selectedItemBuilder;
  final String? label;
  final bool enabled;
  final String? errorText;

  @override
  State<FunInputDropdown<T>> createState() => _FunInputDropdownState<T>();
}

class _FunInputDropdownState<T> extends State<FunInputDropdown<T>> {
  bool _isOpen = false;

  FunInputLabelState _labelState() {
    if (!widget.enabled) {
      return FunInputLabelState.disabled;
    }
    if (widget.errorText != null && widget.errorText!.isNotEmpty) {
      return FunInputLabelState.error;
    }
    if (_isOpen) {
      return FunInputLabelState.focused;
    }
    if (widget.value != null) {
      return FunInputLabelState.filled;
    }
    return FunInputLabelState.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    final dropdown = DropdownButton2<T>(
      key: const ValueKey('FunInputDropdown'),
      items: widget.items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: widget.itemBuilder(context, item),
              ))
          .toList(),
      focusNode: widget.focusNode,
      underline: const SizedBox.shrink(),
      dropdownStyleData: DropdownStyleData(
        scrollbarTheme: ScrollbarThemeData(
          thickness: WidgetStateProperty.all<double>(0),
        ),
        maxHeight: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: FamilyAppTheme.neutralVariant80,
            width: 2,
          ),
        ),
        width: MediaQuery.of(context).size.width -
            48, //24 px border left and right
      ),
      isExpanded: true,
      menuItemStyleData: const MenuItemStyleData(
        height: 58,
      ),
      buttonStyleData: ButtonStyleData(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                _isOpen ? FamilyAppTheme.primary70 : FamilyAppTheme.primary40,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.only(left: 12),
      ),
      style: Theme.of(context).textTheme.labelLarge,
      value: widget.value,
      hint: widget.hint,
      onChanged: widget.enabled
          ? (T? value) {
              if (value != null) {
                widget.onChanged?.call(value);
                widget.focusNode?.unfocus();
              }
            }
          : null,
      iconStyleData: const IconStyleData(
        icon: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            FontAwesomeIcons.chevronDown,
            color: FamilyAppTheme.primary20,
          ),
        ),
        openMenuIcon: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            FontAwesomeIcons.chevronUp,
            color: FamilyAppTheme.primary20,
          ),
        ),
      ),
      onMenuStateChange: (bool isOpen) {
        setState(() {
          _isOpen = isOpen;
        });
      },
      selectedItemBuilder: widget.selectedItemBuilder != null
          ? (BuildContext context) => widget.items
              .map((item) => widget.selectedItemBuilder!(context, item))
              .toList()
          : null,
    );

    return LabeledField(
      label: widget.label,
      labelState: _labelState(),
      child: dropdown,
    );
  }
}
