import 'package:flutter/material.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

class LockedCaptainMessageWidget extends StatelessWidget {
  const LockedCaptainMessageWidget({
    this.isCustomizationUnlocked = false,
    super.key,
  });

  final bool isCustomizationUnlocked;

  @override
  Widget build(BuildContext context) {
    final message = isCustomizationUnlocked
        ? 'Play more Gratitude Games to unlock this!'
        : "Heroes don't save the world in towels. Play Gratitude Game to unlock this!";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FunBubble.captainGenerosity(
        text: message,
      ),
    );
  }
}
