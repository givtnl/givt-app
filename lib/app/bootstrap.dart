import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:givt_app/app/injection/injection.dart' as get_it;
import 'package:givt_app/core/logging/logging.dart';

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

Future<void> bootstrap({
  required FutureOr<Widget> Function() builder,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await LoggingInfo.instance.info('App started');
  await get_it.init();
  await get_it.getIt.allReady();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  await LoggingInfo.instance.info('');
  Bloc.observer = const AppBlocObserver();

  await runZonedGuarded(
    () async => runApp(await builder()),
    (error, stackTrace) async {
      log(error.toString(), stackTrace: stackTrace);
      await LoggingInfo.instance.error(
        error.toString(),
        methodName: stackTrace.toString(),
      );
    },
  );
}
