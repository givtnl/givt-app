import 'package:flutter/material.dart';

class ProfileSwitchButton extends StatelessWidget {
  const ProfileSwitchButton({
    required this.name,
    required this.onClicked,
    super.key,
  });
  final String name;
  final VoidCallback onClicked;

  ButtonStyle getButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
        const Color(0xFFD7D6CE),
      ),
      foregroundColor: WidgetStateProperty.all<Color>(
        Colors.black,
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClicked,
      style: getButtonStyle(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 25,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(name),
        ],
      ),
    );
  }
}
