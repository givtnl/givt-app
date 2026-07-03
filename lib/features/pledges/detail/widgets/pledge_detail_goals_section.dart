import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/pledges/detail/cubit/pledge_detail_cubit.dart';
import 'package:givt_app/features/pledges/shared/pledge_display.dart';
import 'package:givt_app/features/personal_summary/widgets/personal_summary_section_card.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

class PledgeDetailGoalsSection extends StatelessWidget {
  const PledgeDetailGoalsSection({
    required this.goalProgress,
    required this.countryCode,
    super.key,
  });

  final List<PledgeGoalProgress> goalProgress;
  final String countryCode;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return PersonalSummarySectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PersonalSummarySectionHeader(title: locals.pledgesDetailPerGoalTitle),
          const SizedBox(height: 10),
          for (var index = 0; index < goalProgress.length; index++) ...[
            if (index > 0) ...[
              const Divider(height: 16, color: FamilyAppTheme.neutralVariant95),
            ],
            _GoalRow(
              goalProgress: goalProgress[index],
              countryCode: countryCode,
            ),
          ],
        ],
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({
    required this.goalProgress,
    required this.countryCode,
  });

  final PledgeGoalProgress goalProgress;
  final String countryCode;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = FunTheme.of(context);
    final target = goalProgress.target;
    final amountParts = PledgeDisplay.parseGoalAmountFrequency(
      locals: locals,
      goal: goalProgress.goal,
      countryCode: countryCode,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: TitleSmallText(
                  goalProgress.goal.goalName,
                  color: theme.primary20,
                ),
              ),
              if (!amountParts.isAllAtOnce)
                _GoalAmountFrequencyText(
                  parts: amountParts,
                  color: theme.primary50,
                ),
            ],
          ),
        ),
        if (target != null && target > 0) ...[
          FunProgressbar(
            currentProgress:
                goalProgress.given.round().clamp(0, target.round()),
            total: target.round().clamp(1, 999999999),
            displayText: PledgeDisplay.formatGoalProgress(
              given: goalProgress.given,
              target: target,
              countryCode: countryCode,
              locals: locals,
            ),
            backgroundColor: Colors.black.withValues(alpha: 0.1),
            progressColor: FamilyAppTheme.highlight90,
            textColor: FamilyAppTheme.highlight30,
          ),
        ],
      ],
    );
  }
}

class _GoalAmountFrequencyText extends StatelessWidget {
  const _GoalAmountFrequencyText({
    required this.parts,
    required this.color,
  });

  final PledgeGoalAmountFrequencyParts parts;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: parts.amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1.1,
            ),
          ),
          if (parts.unitSuffix != null)
            TextSpan(
              text: parts.unitSuffix,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
                height: 1.1,
              ),
            ),
        ],
      ),
      textAlign: TextAlign.right,
    );
  }
}
