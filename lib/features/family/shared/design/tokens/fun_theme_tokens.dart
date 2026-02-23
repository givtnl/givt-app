import 'package:flutter/material.dart';

/// Abstract token set used by [FunAppTheme]. Implemented by [FunGivtTokens] and [FunGivt4KidsTokens].
abstract interface class FunThemeTokens {
  Color get primaryColor;
  Color get secondaryColor;
  Color get tertiaryColor;

  Color get primary10;
  Color get primary20;
  Color get primary30;
  Color get primary40;
  Color get primary50;
  Color get primary60;
  Color get primary70;
  Color get primary80;
  Color get primary90;
  Color get primary95;
  Color get primary98;
  Color get primary99;

  Color get secondary10;
  Color get secondary20;
  Color get secondary30;
  Color get secondary40;
  Color get secondary70;
  Color get secondary80;
  Color get secondary90;
  Color get secondary95;
  Color get secondary98;
  Color get secondary99;

  Color get tertiary10;
  Color get tertiary20;
  Color get tertiary40;
  Color get tertiary50;
  Color get tertiary80;
  Color get tertiary90;
  Color get tertiary95;
  Color get tertiary98;

  Color get info20;
  Color get info30;
  Color get info40;
  Color get info70;
  Color get info80;
  Color get info90;
  Color get info95;

  Color get highlight20;
  Color get highlight30;
  Color get highlight40;
  Color get highlight50;
  Color get highlight80;
  Color get highlight90;
  Color get highlight95;
  Color get highlight98;
  Color get highlight99;

  Color get error20;
  Color get error30;
  Color get error40;
  Color get error50;
  Color get error60;
  Color get error70;
  Color get error80;
  Color get error90;
  Color get error98;

  Color get stageColorPulse;
  Color get stageColorPodium;
  Color get neutral30;
  Color get neutral40;
  Color get neutral50;
  Color get neutral60;
  Color get neutral70;
  Color get neutral80;
  Color get neutral90;
  Color get neutral95;
  Color get neutral98;
  Color get neutral100;

  Color get neutralVariant40;
  Color get neutralVariant50;
  Color get neutralVariant60;
  Color get neutralVariant80;
  Color get neutralVariant90;
  Color get neutralVariant95;
  Color get neutralVariant99;

  Color get opacityWhite75;
  Color get opacityBlack50;

  Color get disabledTileBackground;
  Color get disabledTileBorder;
  Color get recommendationItemText;
  Color get progressGradient1;
  Color get progressGradient2;
  Color get progressGradient3;
  Color get disabledCameraGrey;
  Color get defaultTextColor;
  Color get downloadAppBackground;
  Color get impactGroupDialogBarrierColor;
  Color get givtBlue;

  String get fontFamily;

  /// Strong (heading/label) weight: SemiBold for Onest (Givt), Bold for Rouna (Givt4Kids).
  FontWeight get fontWeightStrong;

  /// Font size scale from design tokens (FONT_SIZE). Index 0–12 maps to 14, 15, 16, 18, 20, 20, 22, 24, 26, 28, 32, 36, 54.
  double get fontSize0;
  double get fontSize1;
  double get fontSize2;
  double get fontSize3;
  double get fontSize4;
  double get fontSize5;
  double get fontSize6;
  double get fontSize7;
  double get fontSize8;
  double get fontSize9;
  double get fontSize10;
  double get fontSize11;
  double get fontSize12;

  /// Border width scale from design tokens (borderWidth): none (0), thinner (1), thin (1), thick (2), thicker (4).
  double get borderWidthNone;
  double get borderWidthThinner;
  double get borderWidthThin;
  double get borderWidthThick;
  double get borderWidthThicker;

  /// Shadow Y offset from design tokens (shadow-y): none, xs, sm, md, lg, xl.
  double get shadowYNone;
  double get shadowYXs;
  double get shadowYSm;
  double get shadowYMd;
  double get shadowYLg;
  double get shadowYXl;
}
