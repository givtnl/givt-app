import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

enum ChatScriptFunction {
  none(function: _empty),
  pushNotificationPermission(
    function: _askForPushNotificationPermission,
  ),
  registerUser(
    function: _registerUser,
  ),
  ;

  const ChatScriptFunction({
    required this.function,
  });

  final Future<bool> Function(BuildContext context) function;

  static ChatScriptFunction fromString(String value) {
    try {
      return ChatScriptFunction.values.byName(value);
    } catch (error) {
      return ChatScriptFunction.none;
    }
  }

  static Future<bool> _empty(
    BuildContext context,
  ) async {
    return false;
  }

  static Future<bool> _askForPushNotificationPermission(
    BuildContext context,
  ) async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
    return true;
  }

  static Future<bool> _registerUser(
    BuildContext context,
  ) async {
    // KIDS-941: Implement registration
    //throw UnimplementedError();
    return true;
  }
}
