import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_uimodel.dart';

class LevelTile extends StatelessWidget {
  const LevelTile({
    required this.level,
    required this.title,
    required this.subtitle,
    this.unlocked = false,
    this.completed = false,
    this.onTap,
    super.key,
  });

  final int level;
  final String title;
  final String subtitle;
  final bool unlocked;
  final bool completed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FunMissionCard(
      uiModel: FunMissionCardUIModel(
        title: title,
        description: subtitle,
        headerIcon: !unlocked ? FunIcon.lock(iconSize: 24) : null,
        progress: unlocked
            ? GoalCardProgressUImodel(
                amount: completed ? 1 : 0,
                goalAmount: 1,
              )
            : null,
        disabled: !unlocked,
      ),
      onTap: unlocked ? onTap : null,
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.generosityHuntLevelTileClicked,
        parameters: {
          'level': level,
        },
      ),
    );
  }
}
