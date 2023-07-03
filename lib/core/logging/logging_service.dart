import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:givt_app/core/logging/log_message.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin ILoggingInfo {
  Future<void> debug(String message);

  Future<void> info(String message);

  Future<void> warning(String message);

  Future<void> error(String message);
}

class LoggingInfo implements ILoggingInfo {
  factory LoggingInfo() => _singleton;

  LoggingInfo._internal();

  static final LoggingInfo _singleton = LoggingInfo._internal();

  static LoggingInfo get instance => _singleton;

  Future<void> _log(String message, Level level) async {
    log(message);
    final info = await PackageInfo.fromPlatform();
    final guid = await _getGuid();
    var lm = LogMessage(
      guid: guid,
      timestamp: DateTime.now().toUtc().toString(),
      level: level.toString(),
      message: message,
      lang: Intl.getCurrentLocale(),
      appVersion: '${info.version}.${info.buildNumber}',
    );

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final release = androidInfo.version.release;
      final sdkInt = androidInfo.version.sdkInt;
      final manufacturer = androidInfo.manufacturer;
      final model = androidInfo.model;
      final os = 'Operating system: $release (SDK $sdkInt)';
      final device = '$manufacturer $model';
      const tag =
          kReleaseMode ? 'GivtApp.Droid.Production' : 'GivtApp.Droid.Debug';
      lm = lm.copyWith(
        platformID: '2',
        model: device,
        versionOS: os,
        tag: tag,
      );
    }

    if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      final systemName = iosInfo.systemName;
      final version = iosInfo.systemVersion;
      final name = iosInfo.name;
      final model = iosInfo.model;
      final os = 'Operating system: iOS $systemName $version';
      final device = '$name $model';
      const tag = kReleaseMode ? 'GivtApp.iOS.Production' : 'GivtApp.iOS.Debug';
      lm = lm.copyWith(
        platformID: '1',
        model: device,
        versionOS: os,
        tag: tag,
      );
    }
    const key = String.fromEnvironment('LOGIT_API_KEY');
    await http
        .post(
      Uri.https('api.logit.io', '/v2'),
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.value,
        'ApiKey': key,
      },
      body: jsonEncode(
        lm.toJson(),
      ),
    )
        .then((value) {
      if (value.statusCode != 200) {
        log('Error sending log message: ${value.statusCode}');
      }
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
  Future<void> debug(String message) async {
    await _log(message, Level.FINE);
  }

  @override
  Future<void> error(String message) async {
    await _log(message, Level.SEVERE);
  }

  @override
  Future<void> info(String message) async {
    await _log(message, Level.INFO);
  }

  @override
  Future<void> warning(String message) async {
    await _log(message, Level.WARNING);
  }
}
