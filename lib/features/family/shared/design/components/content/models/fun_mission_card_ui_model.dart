import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_uimodel.dart';

class FunMissionCardUiModel {
  FunMissionCardUiModel({
    required this.title,
    required this.description,
    this.actionIcon = FontAwesomeIcons.chevronRight,
    this.progress,
    this.headerIcon,
  });

  final String title;
  final String description;
  final IconData actionIcon;
  final GoalProgressUimodel? progress;
  final IconData? headerIcon;
}
