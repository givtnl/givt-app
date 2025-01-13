import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class NoGoalSetWidget extends StatelessWidget {
  const NoGoalSetWidget({
    required this.onTap,
    super.key,
  });
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FunMissionCard(
      uiModel: FunMissionCardUIModel(
        title: 'Create a Family Goal',
        description: 'Give together',
        headerIcon: FontAwesomeIcons.solidFlag,
      ),
      onTap: onTap,
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.noGoalSetCardClicked,
      ),
    );
  }
}
