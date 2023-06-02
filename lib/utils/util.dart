import 'package:flutter/material.dart';

class Util {
  static final emailRegEx = RegExp(r'^[_a-z0-9-]+(\.[_a-z0-9-]+)*(\+[a-z0-9-]+)?@[a-z0-9-]+(\.[a-z0-9-]+)*$');
  static final navigatorKey = GlobalKey<NavigatorState>();
}
