import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';

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
        headerIcon: FunIcon.solidFlagPlain(
          circleSize: 24,
          iconSize: 24,
          padding: EdgeInsets.zero,
        ),
      ),
      onTap: onTap,
      analyticsEvent: AnalyticsEventName.noGoalSetCardClicked.toEvent(),
    );
  }
}
