import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_bar.dart';

class GoalActiveWidget extends StatelessWidget {
  const GoalActiveWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImpactGroupsCubit, ImpactGroupsState>(
      builder: (context, state) {
        final currentGoal = state.familyGoal;
        final org = state.familyGroup.organisation;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                org.organisationName ?? 'Name Placeholder',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '${context.l10n.familyGoalPrefix}\$${currentGoal.goalAmount}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: GoalProgressBar(goal: currentGoal),
              ),
            ],
          ),
        );
      },
    );
  }
}
