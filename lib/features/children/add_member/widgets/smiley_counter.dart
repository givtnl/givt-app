import 'package:flutter/material.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';

class SmileyCounter extends StatelessWidget {
  const SmileyCounter({
    required this.amount,
    super.key,
  });
  final int amount;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < amount; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: smilePurpleIcon(),
            )
        ],
      ),
    );
  }
}
