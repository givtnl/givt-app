import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/layout/givt_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';

class TopupLoadingBottomSheet extends StatelessWidget {
  const TopupLoadingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GivtBottomSheet(
      title: 'Top up my wallet',
      icon: const CustomCircularProgressIndicator(),
      content: Column(
        children: [
          Text(
            "We're processing your top up",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
