import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/shared/widgets/theme/app_theme_switcher.dart';
import 'package:givt_app/utils/app_theme.dart';

class CustomGreenElevatedButton extends StatelessWidget {
  const CustomGreenElevatedButton(
      {required this.title, required this.onPressed, super.key,});
  final String title;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    if(kDebugMode) {
      final isFamilyApp = AppThemeSwitcher.of(context).isFamilyApp;
      log('CustomGreenElevatedButton isFamilyApp: $isFamilyApp');
    }
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
          textAlign: TextAlign.center,
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
