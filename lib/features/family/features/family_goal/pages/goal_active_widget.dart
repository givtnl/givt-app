import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_goal_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_goal_card_ui_model.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/cubit/impact_groups_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_uimodel.dart';

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
        return FunGoalCard(
          uiModel: FunGoalCardUIModel(
            title: org.organisationName ?? 'Name Placeholder',
            description:
                '${context.l10n.familyGoalPrefix}\$${currentGoal.goalAmount}',
            progress: GoalProgressUimodel(
              amount: currentGoal.amount,
              goalAmount: currentGoal.goalAmount,
              totalAmount: currentGoal.totalAmount,
            ),
          ),
        );
      },
    );
  }
}
