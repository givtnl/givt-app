import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/family/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/family/features/impact_groups/model/goal.dart';
import 'package:givt_app/features/family/features/impact_groups/widgets/goal_card.dart';
import 'package:givt_app/features/family/features/impact_groups/widgets/no_goals_widget.dart';
import 'package:givt_app/features/family/shared/widgets/custom_progress_indicator.dart';
import 'package:givt_app/utils/utils.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImpactGroupsCubit, ImpactGroupsState>(
      listener: (context, state) {
        if (state.error.isNotEmpty) {
          SnackBarHelper.showMessage(
            context,
            text: state.error,
            isError: true,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: state.hasGoals
                ? Stack(
                    children: [
                      Column(
                        children: state.goals
                            .map(
                              (e) => GoalCard(
                                group: state.getGoalGroup(e),
                              ),
                            )
                            .toList(),
                      ),
                      if (state.familyGoal.status == GoalStatus.updating)
                        const CustomCircularProgressIndicator(),
                    ],
                  )
                : const NoGoalsWidget(),
          ),
        );
      },
    );
  }
}
