import 'package:flutter/material.dart';
import 'package:givt_app/utils/color_schemes.g.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Avenir-Medium',
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: lightColorScheme.primary,
      ),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: lightColorScheme.primary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
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
