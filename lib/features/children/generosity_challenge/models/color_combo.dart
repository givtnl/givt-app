import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

enum ColorCombo {
  primary(
    borderColor: AppTheme.primary80,
    backgroundColor: AppTheme.primary98,
    accentColor: AppTheme.primary95,
    textColor: AppTheme.primary40,
  ),
  secondary(
    borderColor: AppTheme.secondary80,
    backgroundColor: AppTheme.secondary98,
    accentColor: AppTheme.secondary95,
    textColor: AppTheme.secondary40,
  ),
  highlight(
    borderColor: AppTheme.highlight80,
    backgroundColor: AppTheme.highlight98,
    accentColor: AppTheme.highlight95,
    textColor: AppTheme.highlight40,
  ),
  tertiary(
    borderColor: AppTheme.tertiary80,
    backgroundColor: AppTheme.tertiary98,
    accentColor: AppTheme.tertiary95,
    textColor: AppTheme.tertiary40,
  ),
  ;

  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;
  final Color borderColor;

  const ColorCombo({
    required this.backgroundColor,
    required this.textColor,
    required this.accentColor,
    required this.borderColor,
  });
}
