import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/features/children/goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app/features/children/goal_tracker/model/goal.dart';
import 'package:givt_app/features/children/goal_tracker/widgets/goal_active_widget.dart';
import 'package:givt_app/features/children/goal_tracker/widgets/goal_completed_widget.dart';
import 'package:givt_app/features/children/goal_tracker/widgets/no_goal_set_widget.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class FamilyGoalTracker extends StatelessWidget {
  const FamilyGoalTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (context.read<GoalTrackerCubit>().state.activeGoal ==
            const Goal.empty()) {
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
        child: BlocBuilder<GoalTrackerCubit, GoalTrackerState>(
          builder: (context, state) {
            switch (state.status) {
              case GoalTrackerStatus.initial:
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                  child: Center(child: CircularProgressIndicator()),
                );
              case GoalTrackerStatus.noGoalSet:
                return const NoGoalSetWidget();
              case GoalTrackerStatus.activeGoal:
                return const GoalActiveWidget();
              case GoalTrackerStatus.completedGoal:
                return const GoalCompletedWidget();
              // ignore: no_default_cases
              default:
                return const NoGoalSetWidget();
            }
          },
        ),
      ),
    );
  }
}
