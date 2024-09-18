import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/utils.dart';

enum ColorCombo {
  primary(
    borderColor: FamilyAppTheme.primary80,
    backgroundColor: FamilyAppTheme.primary98,
    accentColor: FamilyAppTheme.primary95,
    textColor: FamilyAppTheme.primary40,
    darkColor: FamilyAppTheme.primary20,
  ),
  secondary(
    borderColor: FamilyAppTheme.secondary80,
    backgroundColor: FamilyAppTheme.secondary98,
    accentColor: FamilyAppTheme.secondary95,
    textColor: FamilyAppTheme.secondary40,
    darkColor: FamilyAppTheme.secondary20,
  ),
  highlight(
    borderColor: FamilyAppTheme.highlight80,
    backgroundColor: FamilyAppTheme.highlight98,
    accentColor: FamilyAppTheme.highlight95,
    textColor: FamilyAppTheme.highlight40,
    darkColor: FamilyAppTheme.highlight20,
  ),
  tertiary(
    borderColor: FamilyAppTheme.tertiary80,
    backgroundColor: FamilyAppTheme.tertiary98,
    accentColor: FamilyAppTheme.tertiary95,
    textColor: FamilyAppTheme.tertiary40,
    darkColor: FamilyAppTheme.tertiary20,
  ),
  ;

  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;
  final Color borderColor;
  final Color darkColor;

  const ColorCombo({
    required this.backgroundColor,
    required this.textColor,
    required this.accentColor,
    required this.borderColor,
    required this.darkColor,
  });
}
