import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/pledges/detail/cubit/pledge_detail_cubit.dart';
import 'package:givt_app/features/pledges/shared/pledge_display.dart';
import 'package:givt_app/features/personal_summary/widgets/personal_summary_section_card.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

class PledgeDetailSummaryCard extends StatelessWidget {
  const PledgeDetailSummaryCard({
    required this.uiModel,
    required this.countryCode,
    super.key,
  });

  final PledgeDetailUIModel uiModel;
  final String countryCode;

  static const List<Color> segmentColors = [
    Color(0xFFC497F9),
    Color(0xFF55E1E2),
    FamilyAppTheme.primary70,
    FamilyAppTheme.highlight80,
  ];

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = FunTheme.of(context);
    final givenFormatted = PledgeDisplay.formatAmount(
      amount: uiModel.givenSoFar,
      countryCode: countryCode,
    );
    final totalPledged = uiModel.totalPledged;
    final showProgress = uiModel.goalProgress.isNotEmpty;

    return PersonalSummarySectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PersonalSummarySectionHeader(
            title: locals.pledgesDetailGivenSoFarTitle,
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                givenFormatted,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.primary40,
                  height: 1.2,
                ),
              ),
              if (totalPledged != null) ...[
                const SizedBox(width: 4),
                Expanded(
                  child: BodyMediumText(
                    locals.pledgesDetailOfPledged(
                      PledgeDisplay.formatAmount(
                        amount: totalPledged,
                        countryCode: countryCode,
                      ),
                    ),
                    color: theme.primary40,
                  ),
                ),
              ],
            ],
          ),
          if (showProgress) ...[
            const SizedBox(height: 16),
            _SegmentedProgressBar(
              goals: uiModel.goalProgress,
              barTotal: uiModel.group.segmentBarTotal,
              givenSoFar: uiModel.givenSoFar,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                for (var index = 0; index < uiModel.goalProgress.length; index++)
                  _LegendItem(
                    color: segmentColors[index % segmentColors.length],
                    label: uiModel.goalProgress[index].goal.goalName,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Multi-segment progress bar matching Figma / [GivingGoalCard] empty-state pattern.
class _SegmentedProgressBar extends StatelessWidget {
  const _SegmentedProgressBar({
    required this.goals,
    required this.barTotal,
    required this.givenSoFar,
  });

  final List<PledgeGoalProgress> goals;
  final double? barTotal;
  final double givenSoFar;

  @override
  Widget build(BuildContext context) {
    final total = barTotal;
    final remaining = total == null
        ? 0.0
        : (total - givenSoFar).clamp(0.0, total);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 14,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: FamilyAppTheme.neutral90),
            if (total != null && total > 0)
              Row(
                children: [
                  for (var index = 0; index < goals.length; index++)
                    if (goals[index].given > 0)
                      Expanded(
                        flex: _flex(goals[index].given, total),
                        child: ColoredBox(
                          color: PledgeDetailSummaryCard.segmentColors[
                              index %
                                  PledgeDetailSummaryCard.segmentColors.length],
                        ),
                      ),
                  if (remaining > 0)
                    Expanded(
                      flex: _flex(remaining, total),
                      child: const SizedBox.shrink(),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  int _flex(double value, double total) =>
      (value / total * 1000).round().clamp(1, 1000);
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        LabelSmallText(
          label,
          color: theme.neutral50,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
