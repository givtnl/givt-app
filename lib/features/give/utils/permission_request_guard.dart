import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/core/logging/logging_service.dart';

/// Serializes `permission_handler` `.request()` calls.
///
/// The plugin enforces a process-wide native mutex; a second `.request()`
/// while a system dialog is open throws [PlatformException].
class PermissionRequestGuard {
  PermissionRequestGuard._();

  static const String concurrentRequestMessage =
      'A request for permissions is already running';

  static Future<void> _tail = Future<void>.value();

  /// Optional override so unit tests can assert log output without
  /// initializing [LoggingInfo].
  @visibleForTesting
  static void Function(String message)? warningLogger;

  /// Returns true when [error] is the permission_handler in-flight mutex.
  static bool isConcurrentRequest(Object error) {
    if (error is! PlatformException) {
      return false;
    }
    final message = error.message ?? '';
    return message.contains(concurrentRequestMessage);
  }

  /// Runs [action] after any in-flight permission request completes.
  ///
  /// If [action] still throws the concurrent-request [PlatformException],
  /// logs a warning and retries once.
  static Future<T> run<T>(Future<T> Function() action) {
    final result = Completer<T>();
    _tail = _tail.catchError((Object _) {}).then((_) async {
      try {
        result.complete(await _invoke(action));
      } catch (e, s) {
        if (!result.isCompleted) {
          result.completeError(e, s);
        }
      }
    });
    return result.future;
  }

  static Future<T> _invoke<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on PlatformException catch (e) {
      if (!isConcurrentRequest(e)) {
        rethrow;
      }
      _warn(
        'Permission request already running; retrying once. $e',
      );
      return action();
    }
  }

  static void _warn(String message) {
    final logger = warningLogger;
    if (logger != null) {
      logger(message);
      return;
    }
    LoggingInfo.instance.warning(
      message,
      methodName: 'PermissionRequestGuard',
    );
  }

  @visibleForTesting
  static void reset() {
    _tail = Future<void>.value();
    warningLogger = null;
  }
}
