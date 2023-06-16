import 'package:flutter/material.dart';

class Util {
  static final emailRegEx = RegExp(r'^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*(\+[a-zA-Z0-9-]+)?@[a-z0-9-]+(\.[a-zA-Z0-9-]+)*$');
  static final navigatorKey = GlobalKey<NavigatorState>();
}
