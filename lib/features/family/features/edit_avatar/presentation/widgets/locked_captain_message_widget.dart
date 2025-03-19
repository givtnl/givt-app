import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_bubble.dart';

class LockedCaptainMessageWidget extends StatelessWidget {
  const LockedCaptainMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FunBubble.captainGenerosity(
        text:
            "Heroes don't save the world in towels. Play Gratitude Game to unlock this!",
      ),
    );
  }
}
