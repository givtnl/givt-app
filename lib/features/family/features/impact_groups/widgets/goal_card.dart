import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/impact_groups/model/impact_group.dart';
import 'package:givt_app/features/family/shared/widgets/goal_progress_bar/goal_progress_bar.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    required this.group,
    super.key,
  });
  final ImpactGroup group;
  @override
  Widget build(BuildContext context) {
    final goal = group.goal;

    return GestureDetector(
      onTap: () {
        AnalyticsHelper.logEvent(eventName: AmplitudeEvents.goalTrackerTapped);

        context.pushNamed(
          FamilyPages.impactGroupDetails.name,
          extra: group,
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FamilyAppTheme.highlight99,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: FamilyAppTheme.neutralVariant95,
            width: 2,
          ),
        ),
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                goal.orgName,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              if (group.type == ImpactGroupType.family)
                Text(
                  'Family Goal: \$${goal.goalAmount}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: FamilyAppTheme.primary50),
                  textAlign: TextAlign.center,
                )
              else
                Text.rich(
                  TextSpan(
                    text: 'Goal: \$${goal.goalAmount}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: FamilyAppTheme.primary50),
                    children: [
                      TextSpan(
                        text: ' · ',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: FamilyAppTheme.neutralVariant60),
                      ),
                      TextSpan(
                        text: '${group.amountOfMembers} members',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: FamilyAppTheme.tertiary50),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: GoalProgressBar(goal: goal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
