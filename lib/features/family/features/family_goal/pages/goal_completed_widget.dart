import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/cubit/impact_groups_cubit.dart';

class GoalCompletedWidget extends StatelessWidget {
  const GoalCompletedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final impactGroupsCubit = context.watch<ImpactGroupsCubit>();
    final org = impactGroupsCubit.state.familyGroup.organisation;
    return FunMissionCard(
      uiModel: FunMissionCardUiModel(
        title: org.organisationName ?? 'Name Placeholder',
        description: 'Family Goal completed. Great job!',
        headerIcon: FontAwesomeIcons.check,
        actionIcon: FontAwesomeIcons.xmark,
      ),
      onTap: () => impactGroupsCubit
          .dismissGoal(impactGroupsCubit.state.familyGroup.goal.id),
    );
  }
}
