import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

class ConfettiDialog {
  static void show(
    BuildContext context, {
    VoidCallback? onFinished,
  }) {
    Confetti.launch(
      context,
      options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
      onFinished: (overlayEntry) {
        overlayEntry.remove();
        onFinished?.call();
      },
    );
  }
}
