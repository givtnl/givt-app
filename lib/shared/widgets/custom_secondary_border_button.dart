import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

class CustomSecondaryBorderButton extends StatelessWidget {
  const CustomSecondaryBorderButton(
      {required this.title, required this.onPressed, super.key});
  final String title;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    const borderWidth = 2;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: borderWidth / 2),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(
            color: AppTheme.givtLightGreen,
            width: borderWidth.toDouble(),
          ),
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppTheme.givtLightGreen,
                fontWeight: FontWeight.w900,
                fontFamily: 'Avenir',
                fontSize: 18,
              ),
        ),
      ),
    );
  }
}
