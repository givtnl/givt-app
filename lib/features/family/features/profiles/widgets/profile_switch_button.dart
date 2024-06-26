import 'package:flutter/material.dart';

class ProfileSwitchButton extends StatelessWidget {
  const ProfileSwitchButton({
    super.key,
    required this.name,
    required this.onClicked,
  });
  final String name;
  final VoidCallback onClicked;

  ButtonStyle getButtonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color(0xFFD7D6CE),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        Colors.black,
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
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
