import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/shared/models/color_combo.dart';

class TagCategory extends Equatable {
  const TagCategory({
    required this.tags,
    required this.colorCombo,
    required this.displayText,
    required this.iconData,
    this.title,
  });

  final List<Tag> tags;
  final ColorCombo colorCombo;
  final String displayText;
  final IconData iconData;
  final String? title;

  @override
  List<Object?> get props => [tags, colorCombo, displayText, iconData, title];
}
