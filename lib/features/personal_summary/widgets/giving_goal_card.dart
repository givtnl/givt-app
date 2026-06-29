import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/personal_summary/widgets/personal_summary_section_card.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class GivingGoalCard extends StatelessWidget {
  const GivingGoalCard({
    required this.year,
    required this.yearTotal,
    required this.goalAmount,
    required this.goalProgress,
    required this.formattedYearTotal,
    required this.formattedGoalAmount,
    required this.onEdit,
    super.key,
  });

  final int year;
  final double yearTotal;
  final double goalAmount;
  final double goalProgress;
  final String formattedYearTotal;
  final String formattedGoalAmount;
  final VoidCallback onEdit;

  bool get _isGoalReached => goalAmount > 0 && yearTotal >= goalAmount;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final locals = context.l10n;
    final title = _isGoalReached
        ? locals.personalSummaryYouReachedYearGoal(year)
        : locals.personalSummaryYourYearGoal(year);

    return PersonalSummarySectionCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 16,
      borderWidth: 2,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          AnalyticsHelper.logEvent(
            eventName: AnalyticsEventName.editGivingGoalClicked,
          );
          onEdit();
        },
        child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TitleSmallText(title),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        TitleLargeText(
                          formattedYearTotal,
                          color: theme.primary40,
                        ),
                        BodyMediumText(
                          ' ${locals.personalSummaryGoalOfTarget(formattedGoalAmount)}',
                          color: theme.primary40,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _GivingGoalProgressBar(
                    progress: goalProgress.clamp(0, 1),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 16,
                  color: theme.primary20.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class _GivingGoalProgressBar extends StatelessWidget {
  const _GivingGoalProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 12,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: theme.neutral90),
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.secondary80,
                        theme.secondary70,
                        theme.primary80,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
