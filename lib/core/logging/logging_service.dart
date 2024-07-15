import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:givt_app/app/app.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/core/logging/log_message.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:ios_utsname_ext/extension.dart' as extensionIOS;

mixin ILoggingInfo {
  Future<void> debug(String message);

  Future<void> info(String message);

  Future<void> warning(String message);

  Future<void> error(String message);

  Future<void> logRequest(String method, String string, String correlationId);

  void logExceptionForDebug(Object e, {StackTrace? stacktrace});
}

class LoggingInfo implements ILoggingInfo {
  factory LoggingInfo() => _singleton;

  LoggingInfo._internal();

  static final LoggingInfo _singleton = LoggingInfo._internal();

  static LoggingInfo get instance => _singleton;

  Future<void> _log(
    String message,
    String methodName,
    Level level, {
    String? correlationId,
  }) async {
    dev.log(message);
    final info = await PackageInfo.fromPlatform();
    final isDebug = info.packageName.contains('test');
    final guid = await _getGuid();
    var lm = LogMessage(
      guid: guid,
      deviceUTCTimestamp: DateFormat('yyyy-MM-ddTHH:mm:ss').format(
        DateTime.now().toUtc(),
      ),
      level: level.toString(),
      message: message,
      lang: Platform.localeName,
      method: methodName,
      appVersion: '${info.version}.${info.buildNumber}',
      correlationId: correlationId,
    );

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final release = androidInfo.version.release;
      final sdkInt = androidInfo.version.sdkInt;
      final manufacturer = androidInfo.manufacturer;
      final model = androidInfo.model;
      final os = 'Android $release (SDK $sdkInt)';
      final device = '$manufacturer $model';
      final tag = isDebug ? 'GivtApp.Droid.Debug' : 'GivtApp.Droid.Production';
      final deviceId = await _getDeviceGuid();
      lm = lm.copyWith(
        platformID: '2',
        model: device,
        versionOS: os,
        tag: tag,
        deviceId: deviceId,
      );
    }

    if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      final systemName = iosInfo.systemName;
      final version = iosInfo.systemVersion;
      final machineId = iosInfo.utsname.machine;
      final name = machineId.iOSProductName;
      final model = iosInfo.model;
      final os = 'iOS $systemName $version';
      final device = '$name $model';
      final tag = isDebug ? 'GivtApp.iOS.Debug' : 'GivtApp.iOS.Production';
      final deviceId = iosInfo.identifierForVendor;
      lm = lm.copyWith(
        platformID: '1',
        model: device,
        versionOS: os,
        tag: tag,
        deviceId: deviceId,
      );
    }
    const key = String.fromEnvironment('LOGIT_API_KEY');
    await http
        .post(
      Uri.https('api.logit.io', '/v2'),
      headers: {
        'Content-Type': 'application/json',
        'ApiKey': key,
      },
      body: jsonEncode(
        lm.toJson(),
      ),
    )
        .then((value) {
      if (value.statusCode != 202) {
        dev.log('Error sending log message: ${value.statusCode}');
      }
    }).catchError((dynamic e) {
      dev.log('Unknown error while sending log message: $e');
    });
  }

  Future<String?> _getGuid() async {
    final prefs = await SharedPreferences.getInstance();
    final userExt = prefs.getString(UserExt.tag);
    final user = userExt != null
        ? UserExt.fromJson(jsonDecode(userExt) as Map<String, dynamic>)
        : null;
    return user?.guid;
  }

  @override
  Future<void> debug(
    String message, {
    String methodName = '',
  }) async {
    await _log(message, methodName, Level.FINE);
  }

  @override
  Future<void> error(
    String message, {
    String methodName = '',
  }) async {
    await _log(message, methodName, Level.SEVERE);
  }

  @override
  Future<void> info(
    String message, {
    String methodName = '',
  }) async {
    await _log(message, methodName, Level.INFO);
  }

  @override
  Future<void> warning(
    String message, {
    String methodName = '',
  }) async {
    await _log(message, methodName, Level.WARNING);
  }

  /// Get the device guid from shared preferences.
  /// If it doesn't exist, generate a new one and store it.
  /// This guid is used to identify the device in the logs.
  Future<String> _getDeviceGuid() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(_androidDeviceUUIDKey)) {
      return prefs.getString(_androidDeviceUUIDKey)!;
    }

    final uuid = const Uuid().v4();

    await prefs.setString(_androidDeviceUUIDKey, uuid);

    return uuid;
  }

  static const _androidDeviceUUIDKey = 'androidDeviceUUID';

  @override
  void logExceptionForDebug(Object e, {StackTrace? stacktrace}) {
    unawaited(debug(e.toString(), methodName: stacktrace.toString()));
  }

  @override
  Future<void> logRequest(
    String method,
    String url,
    String correlationId,
  ) async {
    await _log(
      '$method: $url',
      'Request',
      Level.INFO,
      correlationId: correlationId,
    );
  }
}
