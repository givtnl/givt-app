import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    required this.title,
    this.backgroundColor = AppTheme.givtLightGreen,
    this.onPressed,
    super.key,
  });

  factory CustomElevatedButton.blue({
    required String title,
    VoidCallback? onPressed,
  }) {
    return CustomElevatedButton(
      title: title,
      onPressed: onPressed,
      backgroundColor: AppTheme.givtBlue,
    );
  }

  final String title;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: Colors.grey,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
    );
  }
}
