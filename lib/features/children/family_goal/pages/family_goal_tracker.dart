import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/features/impact_groups/models/goal.dart';
import 'package:givt_app/features/children/family_goal/pages/goal_active_widget.dart';
import 'package:givt_app/features/children/family_goal/pages/goal_completed_widget.dart';
import 'package:givt_app/features/children/family_goal/pages/no_goal_set_widget.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class FamilyGoalTracker extends StatelessWidget {
  const FamilyGoalTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (context.read<ImpactGroupsCubit>().state.isFamilyGoalDismissed) {
          context.pushNamed(
            Pages.createFamilyGoal.name,
            extra: context.read<FamilyOverviewCubit>(),
          );
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(24),
        decoration: ShapeDecoration(
          color: AppTheme.primary98,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: BlocBuilder<ImpactGroupsCubit, ImpactGroupsState>(
          builder: (context, state) {
            if (state.isFamilyGoalDismissed) {
              return const NoGoalSetWidget();
            }
            if (state.familyGroup.goal.status == FamilyGoalStatus.completed) {
              return const GoalCompletedWidget();
            }
            if (state.familyGroup.goal.status == FamilyGoalStatus.inProgress) {
              return const GoalActiveWidget();
            }
            return const NoGoalSetWidget();
          },
        ),
      ),
    );
  }
}
