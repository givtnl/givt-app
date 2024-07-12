import 'package:flutter/material.dart';
import 'package:givt_app/utils/utils.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppTheme.secondary99,
        ),
        child: const CircularProgressIndicator(
          color: AppTheme.secondary80,
        ),
      ),
    );
  }
}
