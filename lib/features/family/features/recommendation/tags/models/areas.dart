import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';

enum Areas {
  church(
    borderColor: FamilyAppTheme.primary70,
    backgroundColor: FamilyAppTheme.primary98,
    accentColor: FamilyAppTheme.primary95,
    textColor: FamilyAppTheme.primary40,
  ),
  environment(
    borderColor: FamilyAppTheme.primary70,
    backgroundColor: FamilyAppTheme.primary98,
    accentColor: FamilyAppTheme.primary95,
    textColor: FamilyAppTheme.primary40,
  ),
  education(
    borderColor: FamilyAppTheme.secondary80,
    backgroundColor: FamilyAppTheme.secondary98,
    accentColor: FamilyAppTheme.secondary95,
    textColor: FamilyAppTheme.secondary40,
  ),
  basic(
    borderColor: FamilyAppTheme.highlight80,
    backgroundColor: FamilyAppTheme.highlight98,
    accentColor: FamilyAppTheme.highlight95,
    textColor: FamilyAppTheme.highlight40,
  ),
  health(
    borderColor: FamilyAppTheme.tertiary80,
    backgroundColor: FamilyAppTheme.tertiary98,
    accentColor: FamilyAppTheme.tertiary95,
    textColor: FamilyAppTheme.tertiary40,
  ),
  location(
    borderColor: FamilyAppTheme.tertiary80,
    backgroundColor: FamilyAppTheme.tertiary98,
    accentColor: FamilyAppTheme.tertiary95,
    textColor: FamilyAppTheme.tertiary40,
  ),
  disaster(
    borderColor: FamilyAppTheme.highlight80,
    backgroundColor: FamilyAppTheme.highlight98,
    accentColor: FamilyAppTheme.highlight95,
    textColor: FamilyAppTheme.highlight40,
  ),
  primary(
    borderColor: FamilyAppTheme.primary70,
    backgroundColor: FamilyAppTheme.primary98,
    accentColor: FamilyAppTheme.primary95,
    textColor: FamilyAppTheme.primary40,
  ),
  extremelyStrong(
    borderColor: FamilyAppTheme.primary70,
    backgroundColor: FamilyAppTheme.primary98,
    accentColor: FamilyAppTheme.primary80,
    textColor: FamilyAppTheme.primary10,
  ),
  strong(
    borderColor: FamilyAppTheme.primary70,
    backgroundColor: FamilyAppTheme.primary98,
    accentColor: FamilyAppTheme.primary90,
    textColor: FamilyAppTheme.primary30,
  ),
  lessStrong(
    borderColor: FamilyAppTheme.info70,
    backgroundColor: FamilyAppTheme.info95,
    accentColor: FamilyAppTheme.info80,
    textColor: FamilyAppTheme.info20,
  ),
  secondary(
    borderColor: FamilyAppTheme.secondary80,
    backgroundColor: FamilyAppTheme.secondary98,
    accentColor: FamilyAppTheme.secondary95,
    textColor: FamilyAppTheme.secondary40,
  ),
  highlight(
    borderColor: FamilyAppTheme.highlight80,
    backgroundColor: FamilyAppTheme.highlight98,
    accentColor: FamilyAppTheme.highlight95,
    textColor: FamilyAppTheme.highlight40,
  ),
  gold(
    borderColor: FamilyAppTheme.highlight80,
    backgroundColor: FamilyAppTheme.highlight95,
    accentColor: FamilyAppTheme.highlight90,
    textColor: FamilyAppTheme.highlight30,
  ),
  tertiary(
    borderColor: FamilyAppTheme.tertiary80,
    backgroundColor: FamilyAppTheme.tertiary98,
    accentColor: FamilyAppTheme.tertiary95,
    textColor: FamilyAppTheme.tertiary40,
  ),

  ;

  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;
  final Color borderColor;

  const Areas({
    required this.backgroundColor,
    required this.textColor,
    required this.accentColor,
    required this.borderColor,
  });

  factory Areas.fromMap(Map<String, dynamic> map) {
    try {
      return Areas.values.byName(
        (map['area'] as String).toLowerCase(),
      );
    } on ArgumentError {
      return Areas.location;
    }
  }
}
