import 'package:flutter/material.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';

class SmileyCounter extends StatelessWidget {
  const SmileyCounter({
    required this.totalCount,
    this.index,
    super.key,
  });

  final int totalCount;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final smileyCount = index != null ? index! : totalCount;
    final remainingCount = totalCount - smileyCount;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(smileyCount, (_) => _buildSmileyIcon()),
          ...List.generate(
            remainingCount,
            (_) => _buildSmileyIcon(isGrey: true),
          ),
        ],
      ),
    );
  }

  Widget _buildSmileyIcon({bool isGrey = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: isGrey ? smileGreyIcon() : smilePurpleIcon(),
    );
  }
}
