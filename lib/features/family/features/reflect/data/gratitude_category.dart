import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';

class GratitudeCategory extends Equatable {
  const GratitudeCategory({
    required this.tags,
    required this.colorCombo,
    required this.displayText,
    required this.iconData,
  });

  final List<Tag> tags;
  final ColorCombo colorCombo;
  final String displayText;
  final IconData iconData;

  @override
  List<Object?> get props => [tags, colorCombo, displayText, iconData];
}
