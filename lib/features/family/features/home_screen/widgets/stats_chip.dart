import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class StatsChip extends StatelessWidget {
  const StatsChip({required this.text, required this.icon, super.key});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: FamilyAppTheme.primary90,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 15,
          ),
          const SizedBox(width: 8),
          LabelSmallText(text),
        ],
      ),
    );
  }
}
