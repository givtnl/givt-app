import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/utils/app_theme.dart';

typedef ThemedWidgetBuilder = Widget Function(
  BuildContext context,
  ThemeData themeData, {
  required bool isFamilyApp,
});

class AppThemeSwitcherWidget extends StatefulWidget {
  const AppThemeSwitcherWidget({
    required this.builder,
    super.key,
  });

  final ThemedWidgetBuilder builder;

  @override
  State<AppThemeSwitcherWidget> createState() => AppThemeSwitcherWidgetState();
}

class AppThemeSwitcherWidgetState extends State<AppThemeSwitcherWidget> {
  late ThemeData themeData = AppTheme.lightTheme;
  bool isFamilyApp = false;
  final ThemeData _givtTheme = AppTheme.lightTheme;
  final ThemeData _familyTheme = const FamilyAppTheme().toThemeData();

  @override
  void initState() {
    super.initState();
    _setTheme();
  }

  void switchTheme({required bool isFamilyApp}) {
    setState(() {
      if (this.isFamilyApp != isFamilyApp) {
        this.isFamilyApp = isFamilyApp;
        _setTheme();
      }
    });
  }

  void _setTheme() {
    if (isFamilyApp) {
      themeData = _familyTheme;
    } else {
      themeData = _givtTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeSwitcher(
      data: this,
      child: widget.builder(
        context,
        themeData,
        isFamilyApp: isFamilyApp,
      ),
    );
  }
}

class AppThemeSwitcher extends InheritedWidget {
  const AppThemeSwitcher({
    required this.data,
    required super.child,
    super.key,
  });

  final AppThemeSwitcherWidgetState data;

  static AppThemeSwitcherWidgetState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AppThemeSwitcher>()!)
        .data;
  }

  @override
  bool updateShouldNotify(covariant AppThemeSwitcher oldWidget) {
    return data.isFamilyApp != oldWidget.data.isFamilyApp;
  }
}
