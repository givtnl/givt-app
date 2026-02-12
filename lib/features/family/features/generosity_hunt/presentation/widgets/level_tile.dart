import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_uimodel.dart';

class LevelTile extends StatefulWidget {
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
  State<LevelTile> createState() => _LevelTileState();
}

class _LevelTileState extends State<LevelTile> {
  @override
  void dispose() {
    super.dispose();
  }

  void _handleTap() {
    if (!_shouldAllowTap() || widget.onTap == null) {
      return;
    }

    // Call the original onTap callback
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return FunMissionCard(
      uiModel: FunMissionCardUIModel(
        title: widget.title,
        description: widget.subtitle,
        headerIcon: _getHeaderIcon(),
        progress: _getProgress(),
        disabled: !widget.unlocked,
      ),
      onTap: _shouldAllowTap() ? _handleTap : null,
      analyticsEvent: AmplitudeEvents.generosityHuntLevelTileClicked.toEvent(
        parameters: {
          'level': widget.level,
        },
      ),
    );
  }

  FunIcon? _getHeaderIcon() {
    if (!widget.unlocked) {
      return FunIcon.lock(iconSize: 24);
    }

    if (widget.completed) {
      return FunIcon.checkmark(
        circleColor: Colors.transparent,
        iconColor: FunTheme.of(context).primary60,
        circleSize: 24,
        iconSize: 24,
        padding: EdgeInsets.zero,
      );
    }
    
    return null;
  }

  GoalCardProgressUImodel? _getProgress() {
    // Only show progress for unlocked but not completed levels
    if (widget.unlocked && !widget.completed) {
      return GoalCardProgressUImodel(
        amount: 0,
        goalAmount: 1,
      );
    }
    return null;
  }

  bool _shouldAllowTap() {
    // Only allow tap for unlocked but not completed levels
    return widget.unlocked && !widget.completed;
  }
}
