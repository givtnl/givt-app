import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/family_goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app/features/children/family_goal_tracker/widgets/gradient_progress_bar.dart';
import 'package:givt_app/utils/app_theme.dart';

class GoalActiveWidget extends StatelessWidget {
  const GoalActiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalTrackerCubit, GoalTrackerState>(
      builder: (context, state) {
        final currentGoal = state.activeGoal;
        final org = state.organisation;
        final progress = currentGoal.amount / currentGoal.goalAmount.toDouble();
        final totalProgress =
            currentGoal.totalAmount / currentGoal.goalAmount.toDouble();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                org.organisationName ?? 'Name Placeholder',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 17,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Family Goal: \$${currentGoal.goalAmount}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w400,
                    ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: GradientProgressBar(
                  progress: progress > 1 ? 1 : progress,
                  totalProgress: totalProgress > 1 ? 1 : totalProgress,
                  colors: const [
                    AppTheme.highlight90,
                    AppTheme.progressGradient1,
                    AppTheme.progressGradient2,
                    AppTheme.progressGradient3,
                    AppTheme.primary70,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
