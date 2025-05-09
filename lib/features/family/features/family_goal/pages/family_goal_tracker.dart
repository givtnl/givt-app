import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/family_goal/pages/goal_active_widget.dart';
import 'package:givt_app/features/family/features/family_goal/pages/goal_completed_widget.dart';
import 'package:givt_app/features/family/features/family_goal/pages/no_goal_set_widget.dart';
import 'package:givt_app/features/family/features/impact_groups/models/goal.dart';
import 'package:givt_app/features/family/features/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/cubit/impact_groups_cubit.dart';
import 'package:go_router/go_router.dart';

class FamilyGoalTracker extends StatelessWidget {
  const FamilyGoalTracker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void onTap() {
      if (context.read<ImpactGroupsCubit>().state.isFamilyGoalDismissed) {
        context.pushNamed(
          FamilyPages.createFamilyGoal.name,
          extra: context.read<FamilyOverviewCubit>(),
        );
      }
    }

    return BlocBuilder<ImpactGroupsCubit, ImpactGroupsState>(
      builder: (context, state) {
        if (state.isFamilyGoalDismissed) {
          return NoGoalSetWidget(onTap: onTap);
        }
        if (state.familyGroup.goal.status == FamilyGoalStatus.completed) {
          return const GoalCompletedWidget();
        }
        if (state.familyGroup.goal.status == FamilyGoalStatus.inProgress) {
          return const GoalActiveWidget();
        }
        return NoGoalSetWidget(onTap: onTap);
      },
    );
  }
}
