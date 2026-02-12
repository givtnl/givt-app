import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_text_styles.dart';
import 'package:givt_app/features/family/shared/design/tokens/fun_theme_tokens.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

/// Single theme implementation driven by a token set.
/// Use [FunGivtTheme] or [FunGivt4KidsTheme] to get the correct token set.
@immutable
class FunAppTheme extends ThemeExtension<FunAppTheme> {
  const FunAppTheme({required this.tokens});

  final FunThemeTokens tokens;

  // Expose token getters so callers can use FunTheme.of(context).primary40 etc.
  Color get primaryColor => tokens.primaryColor;
  Color get secondaryColor => tokens.secondaryColor;
  Color get tertiaryColor => tokens.tertiaryColor;

  Color get primary10 => tokens.primary10;
  Color get primary20 => tokens.primary20;
  Color get primary30 => tokens.primary30;
  Color get primary40 => tokens.primary40;
  Color get primary50 => tokens.primary50;
  Color get primary60 => tokens.primary60;
  Color get primary70 => tokens.primary70;
  Color get primary80 => tokens.primary80;
  Color get primary90 => tokens.primary90;
  Color get primary95 => tokens.primary95;
  Color get primary98 => tokens.primary98;
  Color get primary99 => tokens.primary99;

  Color get secondary10 => tokens.secondary10;
  Color get secondary20 => tokens.secondary20;
  Color get secondary30 => tokens.secondary30;
  Color get secondary40 => tokens.secondary40;
  Color get secondary70 => tokens.secondary70;
  Color get secondary80 => tokens.secondary80;
  Color get secondary90 => tokens.secondary90;
  Color get secondary95 => tokens.secondary95;
  Color get secondary98 => tokens.secondary98;
  Color get secondary99 => tokens.secondary99;

  Color get tertiary10 => tokens.tertiary10;
  Color get tertiary20 => tokens.tertiary20;
  Color get tertiary40 => tokens.tertiary40;
  Color get tertiary50 => tokens.tertiary50;
  Color get tertiary80 => tokens.tertiary80;
  Color get tertiary90 => tokens.tertiary90;
  Color get tertiary95 => tokens.tertiary95;
  Color get tertiary98 => tokens.tertiary98;

  Color get info20 => tokens.info20;
  Color get info30 => tokens.info30;
  Color get info40 => tokens.info40;
  Color get info70 => tokens.info70;
  Color get info80 => tokens.info80;
  Color get info90 => tokens.info90;
  Color get info95 => tokens.info95;

  Color get highlight20 => tokens.highlight20;
  Color get highlight30 => tokens.highlight30;
  Color get highlight40 => tokens.highlight40;
  Color get highlight50 => tokens.highlight50;
  Color get highlight80 => tokens.highlight80;
  Color get highlight90 => tokens.highlight90;
  Color get highlight95 => tokens.highlight95;
  Color get highlight98 => tokens.highlight98;
  Color get highlight99 => tokens.highlight99;

  Color get error20 => tokens.error20;
  Color get error30 => tokens.error30;
  Color get error40 => tokens.error40;
  Color get error50 => tokens.error50;
  Color get error60 => tokens.error60;
  Color get error70 => tokens.error70;
  Color get error80 => tokens.error80;
  Color get error90 => tokens.error90;
  Color get error98 => tokens.error98;

  Color get stageColorPulse => tokens.stageColorPulse;
  Color get stageColorPodium => tokens.stageColorPodium;
  Color get neutral30 => tokens.neutral30;
  Color get neutral40 => tokens.neutral40;
  Color get neutral50 => tokens.neutral50;
  Color get neutral60 => tokens.neutral60;
  Color get neutral70 => tokens.neutral70;
  Color get neutral80 => tokens.neutral80;
  Color get neutral90 => tokens.neutral90;
  Color get neutral95 => tokens.neutral95;
  Color get neutral98 => tokens.neutral98;
  Color get neutral100 => tokens.neutral100;

  Color get neutralVariant40 => tokens.neutralVariant40;
  Color get neutralVariant50 => tokens.neutralVariant50;
  Color get neutralVariant60 => tokens.neutralVariant60;
  Color get neutralVariant80 => tokens.neutralVariant80;
  Color get neutralVariant90 => tokens.neutralVariant90;
  Color get neutralVariant95 => tokens.neutralVariant95;
  Color get neutralVariant99 => tokens.neutralVariant99;

  Color get opacityWhite75 => tokens.opacityWhite75;
  Color get opacityBlack50 => tokens.opacityBlack50;

  Color get disabledTileBackground => tokens.disabledTileBackground;
  Color get disabledTileBorder => tokens.disabledTileBorder;
  Color get recommendationItemText => tokens.recommendationItemText;
  Color get progressGradient1 => tokens.progressGradient1;
  Color get progressGradient2 => tokens.progressGradient2;
  Color get progressGradient3 => tokens.progressGradient3;
  Color get disabledCameraGrey => tokens.disabledCameraGrey;
  Color get defaultTextColor => tokens.defaultTextColor;
  Color get downloadAppBackground => tokens.downloadAppBackground;
  Color get impactGroupDialogBarrierColor => tokens.impactGroupDialogBarrierColor;
  Color get givtBlue => tokens.givtBlue;

  String get fontFamily => tokens.fontFamily;
  FontWeight get fontWeightStrong => tokens.fontWeightStrong;

  double get fontSize0 => tokens.fontSize0;
  double get fontSize1 => tokens.fontSize1;
  double get fontSize2 => tokens.fontSize2;
  double get fontSize3 => tokens.fontSize3;
  double get fontSize4 => tokens.fontSize4;
  double get fontSize5 => tokens.fontSize5;
  double get fontSize6 => tokens.fontSize6;
  double get fontSize7 => tokens.fontSize7;
  double get fontSize8 => tokens.fontSize8;
  double get fontSize9 => tokens.fontSize9;
  double get fontSize10 => tokens.fontSize10;
  double get fontSize11 => tokens.fontSize11;
  double get fontSize12 => tokens.fontSize12;

  double get borderWidthNone => tokens.borderWidthNone;
  double get borderWidthThinner => tokens.borderWidthThinner;
  double get borderWidthThin => tokens.borderWidthThin;
  double get borderWidthThick => tokens.borderWidthThick;
  double get borderWidthThicker => tokens.borderWidthThicker;

  double get shadowYNone => tokens.shadowYNone;
  double get shadowYXs => tokens.shadowYXs;
  double get shadowYSm => tokens.shadowYSm;
  double get shadowYMd => tokens.shadowYMd;
  double get shadowYLg => tokens.shadowYLg;
  double get shadowYXl => tokens.shadowYXl;

  static const Cubic gentle = Cubic(0.47, 0, 0.23, 1.38);

  Scheme _schemeLight() {
    final base = CorePalette.of(primaryColor.toARGB32());
    final primary = base.primary;
    final secondary = CorePalette.of(secondaryColor.toARGB32()).primary;
    final tertiary = CorePalette.of(tertiaryColor.toARGB32()).primary;
    return Scheme(
      primary: primary.get(50),
      onPrimary: primary.get(99),
      primaryContainer: primary.get(80),
      onPrimaryContainer: primary.get(30),
      secondary: secondary.get(40),
      onSecondary: secondary.get(98),
      secondaryContainer: secondary.get(90),
      onSecondaryContainer: secondary.get(10),
      tertiary: tertiary.get(40),
      onTertiary: tertiary.get(98),
      tertiaryContainer: tertiary.get(80),
      onTertiaryContainer: tertiary.get(10),
      error: base.error.get(40),
      onError: base.error.get(100),
      errorContainer: base.error.get(90),
      onErrorContainer: base.error.get(10),
      background: base.neutral.get(100),
      onBackground: primary.get(10),
      surface: base.neutral.get(99),
      onSurface: base.neutral.get(10),
      outline: base.neutralVariant.get(50),
      outlineVariant: base.neutralVariant.get(80),
      surfaceVariant: base.neutralVariant.get(90),
      onSurfaceVariant: base.neutralVariant.get(30),
      shadow: tertiary.get(0),
      scrim: tertiary.get(0),
      inverseSurface: tertiary.get(20),
      inverseOnSurface: secondary.get(80),
      inversePrimary: primary.get(40),
    );
  }

  ThemeData _base(ColorScheme colorScheme) {
    final fontFamily = tokens.fontFamily;
    final strongWeight = tokens.fontWeightStrong;
    TextStyle withTheme(TextStyle style) =>
        style.copyWith(fontFamily: fontFamily, fontWeight: strongWeight);
    TextStyle bodyWithTheme(TextStyle style) =>
        style.copyWith(fontFamily: fontFamily);
    final textTheme = TextTheme(
      displayLarge: withTheme(FunTextStyles.displayLarge),
      displayMedium: withTheme(FunTextStyles.displayMedium),
      displaySmall: withTheme(FunTextStyles.displaySmall),
      titleLarge: withTheme(FunTextStyles.titleLarge),
      titleMedium: withTheme(FunTextStyles.titleMedium),
      titleSmall: withTheme(FunTextStyles.titleSmall),
      headlineSmall: withTheme(FunTextStyles.headlineSmall),
      headlineMedium: withTheme(FunTextStyles.headlineMedium),
      headlineLarge: withTheme(FunTextStyles.headlineLarge),
      labelSmall: withTheme(FunTextStyles.labelSmall),
      labelMedium: withTheme(FunTextStyles.labelMedium),
      labelLarge: withTheme(FunTextStyles.labelLarge),
      bodySmall: bodyWithTheme(FunTextStyles.bodySmall),
      bodyMedium: bodyWithTheme(FunTextStyles.bodyMedium),
      bodyLarge: bodyWithTheme(FunTextStyles.bodyLarge),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      bottomSheetTheme: BottomSheetThemeData(
        modalBarrierColor: primaryColor.withValues(alpha: 0.5),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
      fontFamily: tokens.fontFamily,
      textTheme: textTheme,
      primaryColor: colorScheme.primary,
      dialogTheme: DialogThemeData(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        barrierColor: primaryColor.withValues(alpha: 0.5),
      ),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(0),
          textStyle: WidgetStatePropertyAll(
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(Color(0xFF41c98e)),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          minimumSize: WidgetStatePropertyAll(Size.fromHeight(45)),
          shape: WidgetStatePropertyAll(
            ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
      ),
      extensions: [this],
      colorScheme: colorScheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return primary80;
            }
            return Colors.white;
          },
        ),
        checkColor: WidgetStateProperty.all(primary20),
      ),
    );
  }

  ThemeData toThemeData() {
    final colorScheme = _schemeLight().toColorScheme(Brightness.light);
    return _base(colorScheme).copyWith(brightness: colorScheme.brightness);
  }

  @override
  ThemeExtension<FunAppTheme> copyWith({FunThemeTokens? tokens}) =>
      FunAppTheme(tokens: tokens ?? this.tokens);

  @override
  FunAppTheme lerp(covariant ThemeExtension<FunAppTheme>? other, double t) {
    if (other is! FunAppTheme) return this;
    return this;
  }
}

extension _SchemeColorScheme on Scheme {
  ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme(
      primary: Color(primary),
      onPrimary: Color(onPrimary),
      primaryContainer: Color(primaryContainer),
      onPrimaryContainer: Color(onPrimaryContainer),
      secondary: Color(secondary),
      onSecondary: Color(onSecondary),
      secondaryContainer: Color(secondaryContainer),
      onSecondaryContainer: Color(onSecondaryContainer),
      tertiary: Color(tertiary),
      onTertiary: Color(onTertiary),
      tertiaryContainer: Color(tertiaryContainer),
      onTertiaryContainer: Color(onTertiaryContainer),
      error: Color(error),
      onError: Color(onError),
      errorContainer: Color(errorContainer),
      onErrorContainer: Color(onErrorContainer),
      outline: Color(outline),
      outlineVariant: Color(outlineVariant),
      surface: Color(surface),
      onSurface: Color(onSurface),
      surfaceContainerHighest: Color(surfaceVariant),
      onSurfaceVariant: Color(onSurfaceVariant),
      inverseSurface: Color(inverseSurface),
      onInverseSurface: Color(inverseOnSurface),
      inversePrimary: Color(inversePrimary),
      shadow: Color(shadow),
      scrim: Color(scrim),
      surfaceTint: Color(primary),
      brightness: brightness,
    );
  }
}
