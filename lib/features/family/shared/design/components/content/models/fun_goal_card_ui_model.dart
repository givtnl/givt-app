import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FunGoalCardUIModel {
  FunGoalCardUIModel({
    required this.title,
    required this.description,
    this.actionIcon = FontAwesomeIcons.chevronRight,
    this.progress,
    this.headerIcon,
  });

  final String title;
  final String description;
  final IconData actionIcon;
  final double? progress;
  final IconData? headerIcon;
}
