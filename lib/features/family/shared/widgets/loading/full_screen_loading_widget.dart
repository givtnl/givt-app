import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class FullScreenLoadingWidget extends StatelessWidget {
  const FullScreenLoadingWidget({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomCircularProgressIndicator(),
          if (text != null) const SizedBox(height: 16),
          if (text != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: BodyMediumText(
                text!,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
