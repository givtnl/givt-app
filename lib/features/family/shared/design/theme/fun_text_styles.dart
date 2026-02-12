import 'package:flutter/material.dart';

import 'package:givt_app/features/family/shared/design/tokens/fun_givt_tokens.dart';

/// Static text styles. Use default (Givt) tokens when no theme in scope.
/// Font family and strong weight come from [FunGivtTokens] (Onest, SemiBold).
class FunTextStyles {
  static String get _fontFamily => FunGivtTokens.instance.fontFamily;
  static FontWeight get _fontWeightStrong =>
      FunGivtTokens.instance.fontWeightStrong;

  static final displayLarge = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 57,
    fontWeight: _fontWeightStrong,
    height: 1.2,
    fontFamily: _fontFamily,
  );

  static final displayMedium = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 45,
    fontWeight: _fontWeightStrong,
    height: 1.2,
    fontFamily: _fontFamily,
  );

  static final displaySmall = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 36,
    fontWeight: _fontWeightStrong,
    height: 1.2,
    fontFamily: _fontFamily,
  );

  static final headlineLarge = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 32,
    fontWeight: _fontWeightStrong,
    height: 1.2,
    fontFamily: _fontFamily,
    fontFeatures: <FontFeature>[
      FontFeature.liningFigures(),
      FontFeature.tabularFigures(),
    ],
  );

  static final headlineMedium = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 28,
    fontWeight: _fontWeightStrong,
    height: 1.2,
    fontFamily: _fontFamily,
  );

  static final headlineSmall = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 24,
    fontWeight: _fontWeightStrong,
    height: 1.2,
    fontFamily: _fontFamily,
  );

  static final titleLarge = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 26,
    fontWeight: _fontWeightStrong,
    height: 1.2,
    fontFamily: _fontFamily,
  );

  static final titleMedium = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 22,
    fontWeight: _fontWeightStrong,
    letterSpacing: 0.05,
    height: 1.2,
    fontFamily: _fontFamily,
  );

  static final titleSmall = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 18,
    fontWeight: _fontWeightStrong,
    letterSpacing: 0.01,
    height: 1.2,
    fontFamily: _fontFamily,
  );

  static final labelLarge = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 20,
    fontWeight: _fontWeightStrong,
    letterSpacing: 0.05,
    fontFamily: _fontFamily,
  );

  static final labelMedium = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 16,
    fontWeight: _fontWeightStrong,
    letterSpacing: 0.05,
    fontFamily: _fontFamily,
  );

  static final labelSmall = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 14,
    fontWeight: _fontWeightStrong,
    letterSpacing: 0.05,
    fontFamily: _fontFamily,
  );

  static final bodyLarge = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.05,
    fontFamily: _fontFamily,
  );

  static final bodyMedium = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.05,
    fontFamily: _fontFamily,
  );

  static final bodySmall = TextStyle(
    color: FunGivtTokens.instance.defaultTextColor,
    fontSize: 15,
    height: 1.4,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    letterSpacing: 0,
  );
}
