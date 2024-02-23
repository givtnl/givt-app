import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/features/children/family_goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app/features/children/family_goal_tracker/widgets/goal_active_widget.dart';
import 'package:givt_app/features/children/family_goal_tracker/widgets/goal_completed_widget.dart';
import 'package:givt_app/features/children/family_goal_tracker/widgets/no_goal_set_widget.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/snack_bar_helper.dart';
import 'package:go_router/go_router.dart';

class FamilyGoalTracker extends StatelessWidget {
  const FamilyGoalTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (context.read<GoalTrackerCubit>().state.status ==
            GoalTrackerStatus.noGoalSet) {
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
        child: BlocConsumer<GoalTrackerCubit, GoalTrackerState>(
          listener: (context, state) {
            if (state.status == GoalTrackerStatus.error) {
              SnackBarHelper.showMessage(
                context,
                text: state.error,
                isError: true,
              );
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case GoalTrackerStatus.loading:
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
