import 'package:flutter/material.dart';
import 'package:givt_app/utils/color_schemes.g.dart';

class AppTheme {
  /// Colors from android AppCompatTheme
  static const givtLightGreen = Color(0xFF41c98e);
  static const givtLightBackgroundGreen = Color(0xFFF5FFF5);
  static const givtBorderBlue = Color(0xFFA4CBF3);
  static const givtDisabledBorderBlue = Color(0xFFDEECFA);
  static const givtDisabledBorderGreen = Color(0x3360DD9B);
  static const givtLightBackgroundBlue = Color(0xFFF3F8FD);
  static const givtBlue = Color(0xFF2e2957);
  static const givtLightGray = Color(0xFFe3e2e7);
  static const givtNeutralGrey = Color(0xFFDCDCE1);
  static const givtDarkerGray = Color(0xFF898989);
  static const givtLightBlue = Color(0xFF4699d2);
  static const givtDarkGrey = Color(0xFF555555);
  static const givtGraycece = Color(0xFFcecece);
  static const givtGrayf7f6f8 = Color(0xFFf7f6f8);
  static const givtGrayf3f3f3 = Color(0xFFf3f3f3);
  static const givtShowcaseBlue = Color(0x0f4e6787);

  static const givtPurple = Color(0xFF2e2957);
  static const givtLightPurple = Color(0xFF5a5387);
  static const givtRed = Color(0xFFD53D4C);
  static const givtOrange = Color(0xFFF17057);
  static const givtAmount = Color(0xFFD2D1D9);
  static const givtYellow = Color(0xFFEDA52E);
  static const givtDarkGreen = Color(0xFF1da96c);
  static const givtGreen60 = Color(0xFF60DD9B);
  static const givtGreen40 = Color(0xFF005231);
  static const softenedGivtPurple = Color(0xFF585479);
  static const presetsButtonColor = Color(0xFF918fa6);
  static const givtLightYellow = Color(0xFFFFF9E3);
  static const givtKidsYellow = Color(0xFFFFE075);

  static const sliderIndicatorFilled = Color(0xFF184869);
  static const sliderIndicatorNotFilled = Color(0xFFD9D9D9);
  static const fontFamily = 'AvenirLTStd';

  static const inputFieldBorderEnabled = Color(0xFFCCCCCC);
  static const inputFieldBorderSelected = Color(0xFF355070);

  static const childItemBackground = Color(0xFF54A1EE);
  static const childItemBlueLight = Color(0xFFBFDBFC);
  static const childItemPendingBackground = Color(0xFFE28D4D);

  static const vpcSuccessBackground = Color(0xFF7DBDA1);

  static const childMonsterPurple = Color(0xFFAD81E1);
  static const childMonsterGreen = Color(0xFFA7CB42);
  static const childMonsterOrange = Color(0xFFFEAD1D);
  static const childMonsterBlue = Color(0xFF69A9D3);

  static const childHistoryPending = Color(0xFFA77F2C);
  static const childHistoryPendingLight = Color(0xFFF2DF7F);
  static const childHistoryPendingDark = Color(0xFF654B14);
  static const childHistoryApproved = Color(0xFF006C47);
  static const childHistoryDeclined = Color(0xFF780F0F);
  static const childHistoryAllowance = Color(0xFF06509B);

  static const childGivingAllowanceCardBorder = Color(0xFFECF1F1);

  static const childGivingAllowanceHint = Color(0xFF617793);

  static const childParentalApprovalDecline = Color(0xFF9A3F3F);

  static const keyboardBackgroundColor = Color(0xFFD2D4D9);

  static const highlight90 = Color(0xFFFAE366);
  static const progressGradient1 = Color(0xFFC6D96D);
  static const progressGradient2 = Color(0xFF9DD273);
  static const progressGradient3 = Color(0xFF74CA79);
  static const highlight80 = Color(0xFFDCC74D);
  static const primary20 = Color(0xFF003920);

  static const primary30 = Color(0xFF005231);
  static const primary40 = Color(0xFF006D42);
  static const primary70 = Color(0xFF40C181);
  static const primary80 = Color(0xFF60DD9B);
  static const primary90 = Color(0xFF6BFCAB);
  static const primary98 = Color(0xFFE9FFED);
  static const primary95 = Color(0xFFC0FFD6);

  static const secondary30 = Color(0xFF004F50);
  static const secondary40 = Color(0xFF00696A);
  static const secondary80 = Color(0xFF4CDADB);
  static const secondary95 = Color(0xFFAEFFFF);
  static const secondary98 = Color(0xFFE2FFFE);

  static const tertiary20 = Color(0xFF431573);
  static const tertiary40 = Color(0xFF744AA5);
  static const tertiary80 = Color(0xFFDAB9FF);
  static const tertiary90 = Color(0xFFEEDBFF);
  static const tertiary95 = Color(0xFFEEDBFF);
  static const tertiary98 = Color(0xFFFFF7FF);

  static const highlight30 = Color(0xFF514700);
  static const highlight40 = Color(0xFF6C5E00);
  static const highlight95 = Color(0xFFFFF1B2);
  static const highlight98 = Color(0xFFFFF9EB);

  static const neutralVariant40 = Color(0xFF5B6055);
  static const neutralVariant50 = Color(0xFF74796D);
  static const neutralVariant80 = Color(0xFFC8C7BF);
  static const neutralVariant90 = Color(0xFFE4E3DB);

  static const error50 = Color(0xFFDC3A26);

  static const familyGoalStepperGray = Color(0xFF9694AB);

  static const generosityChallangeCardBackground = Color(0xFFFFFDF7);
  static const generosityChallangeCardBorder = Color(0xFFEEF2E4);

  static const impactGroupDialogBarrierColor = Color(0xBF404A70);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    fontFamily: 'AvenirLTStd',
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: lightColorScheme.primary,
      ),
      titleMedium: TextStyle(
        color: lightColorScheme.primary,
      ),
      titleSmall: TextStyle(
        color: lightColorScheme.primary,
      ),
      bodyLarge: TextStyle(
        color: lightColorScheme.primary,
      ),
      bodyMedium: TextStyle(
        color: lightColorScheme.primary,
      ),
      bodySmall: TextStyle(
        color: lightColorScheme.primary,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      dragHandleColor: lightColorScheme.onBackground,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: givtGraycece,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: givtLightGreen,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: givtGraycece,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: givtLightGreen,
    ),
    appBarTheme: AppBarTheme(
      actionsIconTheme: IconThemeData(
        color: lightColorScheme.primary,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: lightColorScheme.primary,
      ),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: lightColorScheme.primary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    iconTheme: IconThemeData(
      color: lightColorScheme.primary,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return givtLightGreen;
          }
          return Colors.white;
        },
      ),
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStatePropertyAll(0),
        textStyle: MaterialStatePropertyAll(
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: MaterialStatePropertyAll(Color(0xFF41c98e)),
        foregroundColor: MaterialStatePropertyAll(Colors.white),
        minimumSize: MaterialStatePropertyAll(Size.fromHeight(45)),
        shape: MaterialStatePropertyAll(
          ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    ),
  );
}
