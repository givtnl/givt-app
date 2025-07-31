import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
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
        headerIcon: _getHeaderIcon(),
        progress: _getProgress(),
        disabled: !unlocked,
      ),
      onTap: _shouldAllowTap() ? onTap : null,
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.generosityHuntLevelTileClicked,
        parameters: {
          'level': level,
        },
      ),
    );
  }

  FunIcon? _getHeaderIcon() {
    if (!unlocked) {
      return FunIcon.lock(iconSize: 24);
    }

    if (completed) {
      return FunIcon.checkmark(
        circleColor: Colors.transparent,
        iconColor: FamilyAppTheme.primary60,
        circleSize: 24,
        iconSize: 24,
        padding: EdgeInsets.zero,
      );
    }
    return null;
  }

  GoalCardProgressUImodel? _getProgress() {
    // Only show progress for unlocked but not completed levels
    if (unlocked && !completed) {
      return GoalCardProgressUImodel(
        amount: 0,
        goalAmount: 1,
      );
    }
    return null;
  }

  bool _shouldAllowTap() {
    // Only allow tap for unlocked but not completed levels
    return unlocked && !completed;
  }
}
