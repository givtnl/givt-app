import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_text_styles.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

@immutable
class FamilyAppTheme extends ThemeExtension<FamilyAppTheme> {
  const FamilyAppTheme({
    this.primaryColor = const Color(0xFF006D42),
    this.secondaryColor = const Color(0xFF00696A),
    this.tertiaryColor = const Color(0xFF744AA5),
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;

  static const Cubic gentle = Cubic(0.47, 0, 0.23, 1.38);

// extra colors within pallette
  static const primary20 = Color(0xFF003920);
  static const primary30 = Color(0xFF005231);
  static const primary40 = Color(0xFF006D42);
  static const primary50 = Color(0xFF008954);
  static const primary60 = Color(0xFF15A569);
  static const primary70 = Color(0xFF40C181);
  static const primary80 = Color(0xFF60DD9B);
  static const primary95 = Color(0xFFC0FFD6);
  static const primary90 = Color(0xFF6BFCAB);
  static const primary98 = Color(0xFFE9FFED);
  static const primary99 = Color(0xFFF5FFF5);

  static const secondary10 = Color(0xFF002020);
  static const secondary20 = Color(0xFF003737);
  static const secondary30 = Color(0xFF004F50);
  static const secondary40 = Color(0xFF00696A);
  static const secondary80 = Color(0xFF4CDADB);
  static const secondary90 = Color(0xFF6FF6F7);
  static const secondary95 = Color(0xFFAEFFFF);
  static const secondary98 = Color(0xFFE2FFFE);
  static const secondary99 = Color(0xFFF1FFFE);

  static const tertiary20 = Color(0xFF431573);
  static const tertiary40 = Color(0xFF744AA5);
  static const tertiary50 = Color(0xFF8E63C0);
  static const tertiary80 = Color(0xFFDAB9FF);
  static const tertiary90 = Color(0xFFEEDBFF);
  static const tertiary95 = Color(0xFFEEDBFF);
  static const tertiary98 = Color(0xFFFFF7FF);

  static const info20 = Color(0xFF4E2600);
  static const info30 = Color(0xFF6F3900);
  static const info40 = Color(0xFF914C00);
  static const info90 = Color(0xFFFFDCC3);
  static const info95 = Color(0xFFFFEDE3);

  static const highlight20 = Color(0xFF383000);
  static const highlight30 = Color(0xFF514700);
  static const highlight40 = Color(0xFF6C5E00);
  static const highlight80 = Color(0xFFDCC74D);
  static const highlight90 = Color(0xFFFAE366);
  static const highlight95 = Color(0xFFFFF1B2);
  static const highlight98 = Color(0xFFFFF9EB);
  static const highlight99 = Color(0xFFFFFDF7);

  static const error20 = Color(0xFF680300);
  static const error30 = Color(0xFF920700);
  static const error40 = Color(0xFFB91F0F);
  static const error50 = Color.fromRGBO(220, 58, 38, 1);
  static const error80 = Color(0xFFFFB4A7);
  static const error90 = Color(0xFFFFDAD4);
  static const error98 = Color.fromRGBO(255, 248, 246, 1);

  static const stageColorPulse = Color(0xFFFFD669);
  static const stageColorPodium = Color(0xFFF5A563);
  static const neutral100 = Color(0xFFFEFFFF);

  static const neutralVariant40 = Color(0xFF5B6055);
  static const neutralVariant50 = Color(0xFF74796D);
  static const neutralVariant60 = Color(0xFF8E9286);
  static const neutralVariant80 = Color(0xFFC8C7BF);
  static const neutralVariant90 = Color(0xFFE4E3DB);
  static const neutralVariant95 = Color(0xFFEEF2E4);

  static const opacityWhite75 = Color(0x4CFFFFFF);

  static const disabledTileBackground = Color(0xFFF5F4F5);
  static const disabledTileBorder = Color(0xFFC8C6C9);

  //for recommendation flow
  static const recommendationItemText = Color(0xFF405A66);

  // gradient bar colors
  static const progressGradient1 = Color(0xFFC6D96D);
  static const progressGradient2 = Color(0xFF9DD273);
  static const progressGradient3 = Color(0xFF74CA79);

  //functionally used on screen
  static const disabledCameraGrey = Color(0xFFD8D8D8);
  static const defaultTextColor = FamilyAppTheme.primary20;
  static final historyAllowanceColor =
      const Color(0xFF89BCEF).withAlpha((255 * 0.1).toInt());
  static const downloadAppBackground = Color.fromARGB(255, 46, 41, 87);

  static const impactGroupDialogBarrierColor = Color(0x40006D42);

  static const givtBlue = Color(0xFF2e2957);

  Scheme _schemeLight() {
    final base = CorePalette.of(primaryColor.value);
    final primary = base.primary;
    final secondary = CorePalette.of(secondaryColor.value).primary;
    final tertiary = CorePalette.of(tertiaryColor.value).primary;
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
    const textTheme = TextTheme(
      displayLarge: FunTextStyles.displayLarge,
      displayMedium: FunTextStyles.displayMedium,
      displaySmall: FunTextStyles.displaySmall,
      titleLarge: FunTextStyles.titleLarge,
      titleMedium: FunTextStyles.titleMedium,
      titleSmall: FunTextStyles.titleSmall,
      headlineSmall: FunTextStyles.headlineSmall,
      headlineMedium: FunTextStyles.headlineMedium,
      headlineLarge: FunTextStyles.headlineLarge,
      labelSmall: FunTextStyles.labelSmall,
      labelMedium: FunTextStyles.labelMedium,
      labelLarge: FunTextStyles.labelLarge,
      bodySmall: FunTextStyles.bodySmall,
      bodyMedium: FunTextStyles.bodyMedium,
      bodyLarge: FunTextStyles.bodyLarge,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      bottomSheetTheme: BottomSheetThemeData(
        modalBarrierColor: primaryColor.withOpacity(0.5),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
      fontFamily: 'Rouna',
      textTheme: textTheme,
      primaryColor: colorScheme.primary,
      dialogTheme: DialogTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        barrierColor: primaryColor.withOpacity(0.5),
      ),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
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
      dialogBackgroundColor: Colors.white,
      extensions: [this],
      colorScheme: colorScheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardTheme: CardTheme(
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
  ThemeExtension<FamilyAppTheme> copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? tertiaryColor,
  }) =>
      FamilyAppTheme(
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
        tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      );

  @override
  FamilyAppTheme lerp(
    covariant ThemeExtension<FamilyAppTheme>? other,
    double t,
  ) {
    if (other is! FamilyAppTheme) return this;
    return FamilyAppTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      tertiaryColor: Color.lerp(tertiaryColor, other.tertiaryColor, t)!,
    );
  }
}

extension on Scheme {
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
