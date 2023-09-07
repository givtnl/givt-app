import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:givt_app/app/injection/injection.dart' as get_it;
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/notification/notification.dart';

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
Future<void> _processOfflineDonations(RemoteMessage message) async {
  await get_it.init();
  await get_it.getIt.allReady();
  await LoggingInfo.instance
      .info('Starting process cached givts through push notification');

  await NotificationService.instance.silentNotification(message.data);
}

Future<void> bootstrap({
  required String name,
  required FirebaseOptions options,
  required FutureOr<Widget> Function() builder,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: name,
    options: options,
  );
  await get_it.init();
  await get_it.getIt.allReady();
  FirebaseMessaging.onBackgroundMessage(_processOfflineDonations);

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await runZonedGuarded(
    () async => runApp(await builder()),
    (error, stackTrace) async {
      log(error.toString(), stackTrace: stackTrace);
      await LoggingInfo.instance.error(
        'Errot: $error, StackTrace: $stackTrace',
        methodName: StackTrace.current.toString(),
      );
    },
  );
}
