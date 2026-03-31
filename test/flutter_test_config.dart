import 'dart:async';

import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

// https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // in the future we will setup the injection of test dependencies here
  PackageInfo.setMockInitialValues(
    appName: 'Givt',
    packageName: 'com.givt.test',
    version: '0.0.0',
    buildNumber: '0',
    buildSignature: '',
  );
  if (!getIt.isRegistered<AppConfig>()) {
    getIt.registerSingleton(AppConfig());
  }
  await testMain();
}
