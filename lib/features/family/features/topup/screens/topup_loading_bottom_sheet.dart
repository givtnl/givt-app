import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/layout/givt_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';

class TopupLoadingBottomSheet extends StatelessWidget {
  const TopupLoadingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const GivtBottomSheet(
      title: 'Top up my wallet',
      icon: CustomCircularProgressIndicator(),
      content: Column(
        children: [
          BodyMediumText(
            "We're processing your top up",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
