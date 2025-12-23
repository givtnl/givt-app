import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:givt_app/core/logging/log_message.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ios_utsname_ext/extension.dart' as extensionIOS;
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

mixin ILoggingInfo {
  void debug(String message);

  void info(String message);

  void warning(String message);

  void error(String message);

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
    final otelLogRecord = _toOpenTelemetryLogRecord(lm, level);

    const key = String.fromEnvironment('POSTHOG_API_KEY');
    await http
        .post(
      Uri.https('eu.i.posthog.com', '/i/v1/logs'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $key',
      },
      body: jsonEncode(otelLogRecord),
    )
        .then((value) {
      if (value.statusCode < 200 || value.statusCode >= 300) {
        dev.log('Error sending log message to PostHog: ${value.statusCode}');
      }
    }).catchError((dynamic e) {
      dev.log('Unknown error while sending log message to PostHog: $e');
    });
  }

  Map<String, dynamic> _toOpenTelemetryLogRecord(
    LogMessage lm,
    Level level,
  ) {
    // Map all existing fields into OTel-style attributes.
    final attributes = <String, dynamic>{
      'guid': lm.guid,
      'file': lm.file,
      'lnr': lm.lnr,
      'method': lm.method,
      'model': lm.model,
      'platform_id': lm.platformID,
      'tag': lm.tag,
      'version_os': lm.versionOS,
      'app_version': lm.appVersion,
      'lang': lm.lang,
      'device_id': lm.deviceId,
      'correlation_id': lm.correlationId,
    }..removeWhere((_, value) => value == null);

    return <String, dynamic>{
      // OTel "timestamp" (UTC) – already formatted as ISO-8601.
      // https://opentelemetry.io/docs/specs/otel/logs/data-model/
      'timestamp': lm.deviceUTCTimestamp,
      // Human-readable severity
      'severityText': lm.level,
      // Numeric severity as per OTel ranges (DEBUG/INFO/WARN/ERROR)
      'severityNumber': _mapSeverityNumber(level),
      // The primary message/body for this log record
      'body': lm.message,
      // Name for this kind of event (method name or generic fallback)
      'eventName': lm.method ?? 'application_log',
      // Additional structured context
      'attributes': attributes,
    }..removeWhere((_, value) => value == null);
  }

  int? _mapSeverityNumber(Level level) {
    // Map Dart logging.Level to OpenTelemetry SeverityNumber ranges:
    // DEBUG: 5-8, INFO: 9-12, WARN: 13-16, ERROR: 17-20
    // https://opentelemetry.io/docs/specs/otel/logs/data-model/#severitynumber
    if (level == Level.FINE ||
        level == Level.FINER ||
        level == Level.FINEST) {
      return 5; // DEBUG
    }
    if (level == Level.INFO) {
      return 9; // INFO
    }
    if (level == Level.WARNING) {
      return 13; // WARN
    }
    if (level == Level.SEVERE || level == Level.SHOUT) {
      return 17; // ERROR
    }
    // If we don't recognize the level, omit severityNumber.
    return null;
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
  void debug(
    String message, {
    String methodName = '',
  }) {
    unawaited(_log(message, methodName, Level.FINE));
  }

  @override
  void error(
    String message, {
    String methodName = '',
  }) {
    unawaited(_log(message, methodName, Level.SEVERE));
  }

  @override
  void info(
    String message, {
    String methodName = '',
  }) {
    unawaited(_log(message, methodName, Level.INFO));
  }

  @override
  void warning(
    String message, {
    String methodName = '',
  }) {
    unawaited(_log(message, methodName, Level.WARNING));
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
    debug(e.toString(), methodName: stacktrace.toString());
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
