import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:givt_app/app/firebase_options.dart' as firebase_prod_options;
import 'package:givt_app/app/firebase_options_dev.dart' as firebase_dev_options;
import 'package:givt_app/app/injection/injection.dart' as get_it_injection;
import 'package:givt_app/core/notification/notification_service.dart';
import 'package:givt_app/features/family/app/injection.dart'
    as get_it_injection_family;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:integration_test/integration_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

// https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final (name, options) = await _firebaseOptions;
  await Firebase.initializeApp(
    name: name,
    options: options,
  );

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  // Initialize the dependency injection
  await get_it_injection.init();
  await get_it_injection_family.init();
  await get_it_injection.getIt.allReady();
  // in the future we will setup the injection of test dependencies here

  tz.initializeTimeZones();
  // Initialize the notification service
  await NotificationService.instance.init();
  await testMain();
}

/// Returns the firebase options
/// and the current platform
/// based on the current build flavor
Future<(String, FirebaseOptions)> get _firebaseOptions async {
  final info = await PackageInfo.fromPlatform();
  final isDebug = info.packageName.contains('test');

  final name = isDebug ? 'givt-dev-pre' : 'givtapp-ebde1';
  final options = isDebug
      ? firebase_dev_options.DefaultFirebaseOptions.currentPlatform
      : firebase_prod_options.DefaultFirebaseOptions.currentPlatform;

  return (name, options);
}
