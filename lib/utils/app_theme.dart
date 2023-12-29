import 'package:flutter/material.dart';
import 'package:givt_app/utils/color_schemes.g.dart';

class AppTheme {
  /// Colors from android AppCompatTheme
  static const givtLightGreen = Color(0xFF41c98e);
  static const givtBlue = Color(0xFF2e2957);
  static const givtLightGray = Color(0xFFe3e2e7);
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
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: givtLightGreen,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
        borderRadius: const BorderRadius.all(
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
