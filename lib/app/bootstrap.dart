import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:givt_app/app/firebase_options.dart' as firebase_prod_options;
import 'package:givt_app/app/firebase_options_dev.dart' as firebase_dev_options;
import 'package:givt_app/app/injection/injection.dart' as get_it_injection;
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/notification/notification.dart';
import 'package:givt_app/features/family/app/injection.dart'
    as get_it_injection_family;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

@pragma('vm:entry-point')
Future<void> _processBackgroundNotification(RemoteMessage message) async {
  final (name, options) = await _firebaseOptions;
  await Firebase.initializeApp(
    name: name,
    options: options,
  );

  // Initialize the dependency injection
  await get_it_injection.init();
  await get_it_injection_family.init();
  await get_it_injection.getIt.allReady();

  // Initialize the notification service
  await NotificationService.instance.init();
  await NotificationService.instance.silentNotification(message.data);
}

Future<void> bootstrap(
  FutureOr<Widget> Function() builder,
) async {
  // Make sure WidgetsFlutterBinding is initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  final (name, options) = await _firebaseOptions;
  await Firebase.initializeApp(
    name: name,
    options: options,
  );

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );

  // Initialize the dependency injection
  await get_it_injection.init();
  await get_it_injection_family.init();
  await get_it_injection.getIt.allReady();

  LoggingInfo.instance.info('App started');

  await FirebaseMessaging.instance.requestPermission();

  // Process the notification when the app is in the background
  // Only works on Android, iOS is buggy
  FirebaseMessaging.onBackgroundMessage(_processBackgroundNotification);

  // Process of notifications
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    await NotificationService.instance.navigateFirebaseNotification(message);
  });

  tz.initializeTimeZones();

  FlutterError.onError = (details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  Bloc.observer = const AppBlocObserver();

  runApp(await builder());
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
