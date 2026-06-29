import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

class GivingGoalMonthlyHintBanner extends StatelessWidget {
  const GivingGoalMonthlyHintBanner({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.secondary95,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.solidHeart,
            size: 20,
            color: theme.secondary30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: LabelMediumText(
              text,
              color: theme.secondary30,
            ),
          ),
        ],
      ),
    );
  }
}
