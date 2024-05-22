import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/dialogs/chat_confetti_dialog.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/utils/chat_script_registration_handler.dart';

enum ChatScriptFunction {
  none(function: _empty),
  pushNotificationPermission(
    function: _askForPushNotificationPermission,
  ),
  registerUser(
    function: _registerUser,
  ),
  showConfetti(
    function: _showConfetti,
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
    return getIt<ChatScriptRegistrationHandler>().handleRegistration();
  }

  static Future<bool> _showConfetti(
    BuildContext context,
  ) async {
    await ChatConfettiDialog.showChatConfettiDialog(context);
    return true;
  }
}
