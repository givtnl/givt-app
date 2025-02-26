import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/widgets/bottom_sheet_layout.dart';

class AiGameExplanationSheet extends StatelessWidget {
  const AiGameExplanationSheet({super.key});

  // Enable Captain Ai
  // Maybe later

  @override
  Widget build(BuildContext context) {
    return FunBottomSheet(
      title: 'Captain Ai is here to help improve your conversation',
      content: const SizedBox.shrink(),

    );
  }
}
