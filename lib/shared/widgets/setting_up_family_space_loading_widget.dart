import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';

class SettingUpFamilySpaceLoadingWidget extends StatelessWidget {
  const SettingUpFamilySpaceLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomCircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Nearly there...',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
