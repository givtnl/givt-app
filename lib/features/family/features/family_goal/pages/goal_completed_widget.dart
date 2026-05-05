import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
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
      uiModel: FunMissionCardUIModel(
        title: org.organisationName ?? 'Name Placeholder',
        description: 'Family Goal completed. Great job!',
        headerIcon: FunIcon.xmarkPlain(),
        actionIcon: FontAwesomeIcons.xmark,
      ),
      onTap: () => impactGroupsCubit.dismissGoal(
        impactGroupsCubit.state.familyGroup.goal.id,
      ),
      analyticsEvent: AnalyticsEventName.goalCompletedCardClicked.toEvent(
        parameters: {
          'organisation':
              impactGroupsCubit.state.familyGroup.organisation.organisationName,
        },
      ),
    );
  }
}
