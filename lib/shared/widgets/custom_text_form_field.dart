import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    required this.controller,
    this.hintText,
    super.key,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          labelText: hintText,
          suffixIcon: suffixIcon,
          errorMaxLines: 2,
          labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
              ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          errorStyle: const TextStyle(
            height: 0,
          ),
        ),
      ),
    );
  }
}
