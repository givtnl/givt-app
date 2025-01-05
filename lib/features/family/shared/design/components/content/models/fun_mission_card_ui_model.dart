import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_uimodel.dart';

class FunMissionCardUIModel {
  FunMissionCardUIModel({
    required this.title,
    required this.description,
    this.actionIcon = FontAwesomeIcons.chevronRight,
    this.progress,
    this.headerIcon,
    this.namedPage,
  });

  final String title;
  final String description;
  final IconData actionIcon;
  final GoalProgressUImodel? progress;
  final IconData? headerIcon;
  final String? namedPage;
}
