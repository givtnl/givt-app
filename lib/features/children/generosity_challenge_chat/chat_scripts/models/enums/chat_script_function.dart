import 'package:flutter/material.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';

enum ChatScriptFunction {
  none(function: _empty),
  pushNotificationPermission(
    function: _askForPushNotificationPermission,
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
