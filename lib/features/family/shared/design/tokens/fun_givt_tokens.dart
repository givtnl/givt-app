// When design-tokens/source/givt.tokens.json is present, run: dart run tool/gen_tokens.dart
// to regenerate this file from the token JSON. Until then, this hand-written implementation is used.

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/tokens/fun_theme_tokens.dart';

/// Givt design tokens (green primary, Onest font).
class FunGivtTokens implements FunThemeTokens {
  FunGivtTokens._();
  static final FunGivtTokens instance = FunGivtTokens._();

  @override
  Color get primaryColor => const Color(0xFF006D42);
  @override
  Color get secondaryColor => const Color(0xFF00696A);
  @override
  Color get tertiaryColor => const Color(0xFF744AA5);

  @override
  Color get primary10 => const Color(0xFF002111);
  @override
  Color get primary20 => const Color(0xFF003920);
  @override
  Color get primary30 => const Color(0xFF005231);
  @override
  Color get primary40 => const Color(0xFF006D42);
  @override
  Color get primary50 => const Color(0xFF008954);
  @override
  Color get primary60 => const Color(0xFF15A569);
  @override
  Color get primary70 => const Color(0xFF40C181);
  @override
  Color get primary80 => const Color(0xFF60DD9B);
  @override
  Color get primary90 => const Color(0xFF6BFCAB);
  @override
  Color get primary95 => const Color(0xFFC0FFD6);
  @override
  Color get primary98 => const Color(0xFFE9FFED);
  @override
  Color get primary99 => const Color(0xFFF5FFF5);

  @override
  Color get secondary10 => const Color(0xFF002020);
  @override
  Color get secondary20 => const Color(0xFF003737);
  @override
  Color get secondary30 => const Color(0xFF004F50);
  @override
  Color get secondary40 => const Color(0xFF00696A);
  @override
  Color get secondary70 => const Color(0xFF4CDADB);
  @override
  Color get secondary80 => const Color(0xFF4CDADB);
  @override
  Color get secondary90 => const Color(0xFF6FF6F7);
  @override
  Color get secondary95 => const Color(0xFFAEFFFF);
  @override
  Color get secondary98 => const Color(0xFFE2FFFE);
  @override
  Color get secondary99 => const Color(0xFFF1FFFE);

  @override
  Color get tertiary10 => const Color(0xFF2A0053);
  @override
  Color get tertiary20 => const Color(0xFF431573);
  @override
  Color get tertiary40 => const Color(0xFF744AA5);
  @override
  Color get tertiary50 => const Color(0xFF8E63C0);
  @override
  Color get tertiary80 => const Color(0xFFDAB9FF);
  @override
  Color get tertiary90 => const Color(0xFFEEDBFF);
  @override
  Color get tertiary95 => const Color(0xFFEEDBFF);
  @override
  Color get tertiary98 => const Color(0xFFFFF7FF);

  @override
  Color get info20 => const Color(0xFF4E2600);
  @override
  Color get info30 => const Color(0xFF6F3900);
  @override
  Color get info40 => const Color(0xFF914C00);
  @override
  Color get info70 => Color.fromRGBO(240, 150, 72, 1);
  @override
  Color get info80 => const Color(0xFFE6A87F);
  @override
  Color get info90 => const Color(0xFFFFDCC3);
  @override
  Color get info95 => const Color(0xFFFFEDE3);

  @override
  Color get highlight20 => const Color(0xFF383000);
  @override
  Color get highlight30 => const Color(0xFF514700);
  @override
  Color get highlight40 => const Color(0xFF6C5E00);
  @override
  Color get highlight50 => const Color(0xFF877700);
  @override
  Color get highlight80 => const Color(0xFFDCC74D);
  @override
  Color get highlight90 => const Color(0xFFFAE366);
  @override
  Color get highlight95 => const Color(0xFFFFF1B2);
  @override
  Color get highlight98 => const Color(0xFFFFF9EB);
  @override
  Color get highlight99 => const Color(0xFFFFFDF7);

  @override
  Color get error20 => const Color(0xFF680300);
  @override
  Color get error30 => const Color(0xFF920700);
  @override
  Color get error40 => const Color(0xFFB91F0F);
  @override
  Color get error50 => Color.fromRGBO(220, 58, 38, 1);
  @override
  Color get error60 => const Color(0xFFE06A5F);
  @override
  Color get error70 => const Color(0xFFFF8A77);
  @override
  Color get error80 => const Color(0xFFFFB4A7);
  @override
  Color get error90 => const Color(0xFFFFDAD4);
  @override
  Color get error98 => Color.fromRGBO(255, 248, 246, 1);

  @override
  Color get stageColorPulse => const Color(0xFFFFD669);
  @override
  Color get stageColorPodium => const Color(0xFFF5A563);
  @override
  Color get neutral30 => const Color(0xFF474741);
  @override
  Color get neutral40 => const Color(0xFF5F5F59);
  @override
  Color get neutral50 => const Color(0xFF787771);
  @override
  Color get neutral60 => const Color(0xFF91918A);
  @override
  Color get neutral70 => const Color(0xFFACABA4);
  @override
  Color get neutral80 => const Color(0xFFC8C7BF);
  @override
  Color get neutral90 => const Color(0xFFE4E3DB);
  @override
  Color get neutral95 => const Color(0xFFF3F1E9);
  @override
  Color get neutral98 => const Color(0xFFFBF9F1);
  @override
  Color get neutral100 => const Color(0xFFFEFFFF);

  @override
  Color get neutralVariant40 => const Color(0xFF5B6055);
  @override
  Color get neutralVariant50 => const Color(0xFF74796D);
  @override
  Color get neutralVariant60 => const Color(0xFF8E9286);
  @override
  Color get neutralVariant80 => const Color(0xFFC8C7BF);
  @override
  Color get neutralVariant90 => const Color(0xFFE4E3DB);
  @override
  Color get neutralVariant95 => const Color(0xFFEEF2E4);
  @override
  Color get neutralVariant99 => Color.fromRGBO(254, 252, 244, 1);

  @override
  Color get opacityWhite75 => const Color(0x4CFFFFFF);
  @override
  Color get opacityBlack50 => const Color(0x80000000);

  @override
  Color get disabledTileBackground => const Color(0xFFF5F4F5);
  @override
  Color get disabledTileBorder => const Color(0xFFC8C6C9);
  @override
  Color get recommendationItemText => const Color(0xFF405A66);
  @override
  Color get progressGradient1 => const Color(0xFFC6D96D);
  @override
  Color get progressGradient2 => const Color(0xFF9DD273);
  @override
  Color get progressGradient3 => const Color(0xFF74CA79);
  @override
  Color get disabledCameraGrey => const Color(0xFFD8D8D8);
  @override
  Color get defaultTextColor => primary20;
  @override
  Color get downloadAppBackground => const Color.fromARGB(255, 46, 41, 87);
  @override
  Color get impactGroupDialogBarrierColor => const Color(0x40006D42);
  @override
  Color get givtBlue => const Color(0xFF2e2957);

  @override
  String get fontFamily => 'Onest';

  @override
  FontWeight get fontWeightStrong => FontWeight.w600; // SemiBold for Onest

  @override
  double get fontSize0 => 14;
  @override
  double get fontSize1 => 15;
  @override
  double get fontSize2 => 16;
  @override
  double get fontSize3 => 18;
  @override
  double get fontSize4 => 20;
  @override
  double get fontSize5 => 20;
  @override
  double get fontSize6 => 22;
  @override
  double get fontSize7 => 24;
  @override
  double get fontSize8 => 26;
  @override
  double get fontSize9 => 28;
  @override
  double get fontSize10 => 32;
  @override
  double get fontSize11 => 36;
  @override
  double get fontSize12 => 54;

  @override
  double get borderWidthNone => 0;
  @override
  double get borderWidthThinner => 1;
  @override
  double get borderWidthThin => 1;
  @override
  double get borderWidthThick => 2;
  @override
  double get borderWidthThicker => 4;

  @override
  double get shadowYNone => 0;
  @override
  double get shadowYXs => 0;
  @override
  double get shadowYSm => 0;
  @override
  double get shadowYMd => 0;
  @override
  double get shadowYLg => 0;
  @override
  double get shadowYXl => 0;
}
