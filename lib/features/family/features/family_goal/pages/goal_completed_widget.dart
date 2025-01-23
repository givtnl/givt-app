import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/cubit/impact_groups_cubit.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

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
      onTap: () => impactGroupsCubit
          .dismissGoal(impactGroupsCubit.state.familyGroup.goal.id),
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.goalCompletedCardClicked,
        parameters: {
          'organisation':
              impactGroupsCubit.state.familyGroup.organisation.organisationName,
        },
      ),
    );
  }
}
