import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          color: FamilyAppTheme.primary95,
        ),
        child: const CircularProgressIndicator(
          color: FamilyAppTheme.primary30,
          strokeWidth: 6,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}
