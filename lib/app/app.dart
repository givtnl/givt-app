import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/app_router.dart';
import 'package:givt_app/core/notification/notification.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/family_goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
import 'package:givt_app/utils/utils.dart';

class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    // Make the status bar transparent on Android
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    AnalyticsHelper.init(const String.fromEnvironment('AMPLITUDE_KEY'));

    resetAppBadge();

    /// Setup firebase messaging for background notifications
    final notificationService = getIt<NotificationService>();
    notificationService.init().then(
          (_) => FirebaseMessaging.onMessage.listen(
            (RemoteMessage message) async {
              if (message.data.isEmpty) {
                return;
              }
              await NotificationService.instance.silentNotification(
                message.data,
              );
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthCubit(
              getIt(),
            )..checkAuth(),
            lazy: false,
          ),
          BlocProvider(
            create: (_) => InfraCubit(
              getIt(),
            ),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => GoalTrackerCubit(
              getIt(),
              getIt(),
              context.read<AuthCubit>(),
            ),
            lazy: false,
          ),
        ],
        child: const _AppView(),
      );

  Future<void> resetAppBadge() async {
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      await FlutterAppBadger.removeBadge();
    }
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is US, then always return en_US
        if (locale!.countryCode == 'US') {
          return const Locale('en', 'US');
        }

        for (final supportedLocale in supportedLocales
            .where((element) => element.countryCode != 'US')) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }

        // Return a default locale if we don't support the user's locale
        return supportedLocales
            .where((element) => element.languageCode == 'en')
            .first;
      },
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routerDelegate: AppRouter.router.routerDelegate,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaler
            .clamp(minScaleFactor: 1, maxScaleFactor: 1.2);

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: scale),
          child: child!,
        );
      },
    );
  }
}
