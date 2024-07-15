import 'dart:developer';

import 'package:givt_app/core/logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  AppConfig() {
    _init();
  }

  bool isTestApp = false;
  late PackageInfo packageInfo;

  Future<void> _init() async {
    await _getPackageInfo();
  }

  Future<void> _getPackageInfo() async {
    try {
      packageInfo = await PackageInfo.fromPlatform();
      isTestApp = true == packageInfo.packageName.contains('test');
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
    }
  }
}
