import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/utils/app_theme.dart';

class FamilySearchField extends StatelessWidget {
  const FamilySearchField(
      {required this.controller,
      this.focusNode,
      this.autofocus,
      this.autocorrect,
      this.onChanged,
      super.key,});

  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final bool? autocorrect;

  /// Invoked upon user input.
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autofocus ?? false,
      autocorrect: autocorrect ?? true,
      onChanged: onChanged,
      controller: controller,
      focusNode: focusNode,
      style: Theme.of(context).textTheme.labelLarge,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        suffixIcon: GestureDetector(
          onTap: () {
            controller.clear();
            onChanged?.call('');
          },
          child: Visibility(
            visible: controller.text.isNotEmpty,
            child: const SizedBox(
              width: 48,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: FaIcon(
                    FontAwesomeIcons.xmark,
                    color: AppTheme.primary30,
                  ),
                ),
              ),
            ),
          ),
        ),
        prefixIcon: const SizedBox(
          width: 48,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: AppTheme.primary30,
              ),
            ),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: 'Search',
        hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.neutralVariant40,
            ),
        enabledBorder: enabledInputBorder,
        focusedBorder: selectedInputBorder,
      ),
    );
  }

  InputBorder get enabledInputBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppTheme.inputFieldBorderEnabled,
          width: 2,
        ),
      );

  InputBorder get selectedInputBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppTheme.inputFieldBorderSelected,
          width: 2,
        ),
      );
}
