import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

class YearBanner extends StatelessWidget {
  const YearBanner(this.year, {super.key});
  final String year;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 20),
      color: AppTheme.givtLightPurple,
      child: Text(
        year,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
