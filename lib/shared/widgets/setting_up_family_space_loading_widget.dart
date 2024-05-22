
import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';

class SettingUpFamilySpaceLoadingWidget extends StatelessWidget {
  const SettingUpFamilySpaceLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.l10n.holdOnSetUpFamily,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const CircularProgressIndicator.adaptive(),
        ],
      ),
    );
  }
}
