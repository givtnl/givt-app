import 'package:flutter/material.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';

enum ChatScriptFunctions {
  none(function: _empty),
  pushNotificationPermission(
    function: _askForPushNotificationPermission,
  ),
  ;

  const ChatScriptFunctions({
    required this.function,
  });

  final Future<bool> Function(BuildContext context) function;

  static ChatScriptFunctions fromString(String value) {
    try {
      return ChatScriptFunctions.values.byName(value);
    } catch (error) {
      return ChatScriptFunctions.none;
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
    await showDialog<void>(
      context: context,
      builder: (_) => const WarningDialog(
        title: 'Placeholder',
        content: 'Here will be a push notification permission ask soon ;)',
      ),
    );
    return true;
  }
}
