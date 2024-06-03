import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/app_theme.dart';

extension RouteExtensions on Widget {
  Route<dynamic> toRoute(BuildContext context) {
    return MaterialPageRoute(
      builder: (context) =>
          Theme(data: const FamilyAppTheme().toThemeData(), child: this),
    );
  }

  PageRoute<dynamic> toPageRoute(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: (context) => this);
    } else {
      return MaterialPageRoute(builder: (context) => this);
    }
  }

  Page<dynamic> toPage({
    String? key,
    Object? arguments,
  }) {
    if (Platform.isIOS) {
      return CupertinoPage(
        key: key == null ? null : ValueKey(key),
        arguments: arguments,
        child: this,
      );
    } else {
      return MaterialPage(
        key: key == null ? null : ValueKey(key),
        arguments: arguments,
        child: this,
      );
    }
  }
}
