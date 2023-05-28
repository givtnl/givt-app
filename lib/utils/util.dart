import 'package:flutter/material.dart';

class Util {
  static final emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final navigatorKey = GlobalKey<NavigatorState>();
}
