import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

class ParentalApprovalLoadingPage extends StatelessWidget {
  const ParentalApprovalLoadingPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppTheme.givtBlue,
      ),
    );
  }
}
