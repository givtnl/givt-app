import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

class ParentalApprovalLoadingPage extends StatelessWidget {
  const ParentalApprovalLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.35,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppTheme.givtBlue,
        ),
      ),
    );
  }
}
