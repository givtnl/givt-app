import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

class CustomGreenElevatedButton extends StatelessWidget {
  const CustomGreenElevatedButton(
      {required this.title, required this.onPressed, super.key});
  final String title;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.givtLightGreen,
          disabledBackgroundColor: Colors.grey,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                //  fontFamily: 'Avenir',
              ),
        ),
      ),
    );
  }
}
