import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/loading/full_screen_loading_widget.dart';

class GratefulLoading extends StatelessWidget {
  const GratefulLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const FullScreenLoadingWidget(
        text:
            'We are finding you some opportunities to turn your gratitude into generosity');
  }
}
