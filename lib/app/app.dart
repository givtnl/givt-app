import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/app_router.dart';
import 'package:givt_app/core/notification/notification.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
import 'package:givt_app/shared/widgets/theme/app_theme_switcher.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:package_info_plus/package_info_plus.dart';

class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  GlobalKey<AppThemeSwitcherWidgetState> themeKey =
      GlobalKey<AppThemeSwitcherWidgetState>();

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

    PackageInfo.fromPlatform().then(
      (info) {
        AnalyticsHelper.setAppMetadata(
          appName: 'Givt.App',
          appType: 'mobile',
          appVersion: info.version,
        );

        AnalyticsHelper.init(
          const String.fromEnvironment('POSTHOG_API_KEY'),
        );
      },
    );

    unawaited(initializeStripe());

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
              networkInfo: getIt(),
            )..checkAuth(isAppStartupCheck: true),
            lazy: false,
          ),
          BlocProvider(
            create: (_) => InfraCubit(
              getIt(),
              getIt(),
            ),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => ImpactGroupsCubit(
              getIt(),
              getIt(),
            ),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => RegistrationBloc(
              authCubit: context.read<AuthCubit>(),
              authRepositoy: getIt(),
            ),
          ),
        ],
        child: AppThemeSwitcherWidget(
          key: themeKey,
          builder: (
            BuildContext context,
            ThemeData themeData, {
            required bool isFamilyApp,
          }) {
            if (kDebugMode) {
              log('Rebuilding app with theme, isFamilyApp: $isFamilyApp');
            }
            return _AppView(themeData: themeData);
          },
        ),
      );

  Future<void> initializeStripe() async {
    Stripe.publishableKey = const String.fromEnvironment('STRIPE_PK');
    Stripe.merchantIdentifier =
        const String.fromEnvironment('STRIPE_MERCHANT_ID');

    await Stripe.instance.applySettings();
  }
}

class _AppView extends StatefulWidget {
  const _AppView({required this.themeData});

  final ThemeData themeData;

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  Locale? _momentLocale;

  void _syncMomentLocalization(Locale locale) {
    if (_momentLocale == locale) return;
    _momentLocale = locale;

    final momentLocalization =
        MomentLocalizations.byLocale(locale.toLanguageTag()) ??
        MomentLocalizations.byLanguage(locale.languageCode);
    if (momentLocalization != null) {
      Moment.setGlobalLocalization(momentLocalization);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: widget.themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: Util.resolveLocale,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routerDelegate: AppRouter.router.routerDelegate,
      builder: (context, child) {
        _syncMomentLocalization(Localizations.localeOf(context));

        final mediaQueryData = MediaQuery.of(context);
        final currentScale = mediaQueryData.textScaler.scale(1.0);
        final clampedScale = currentScale.clamp(1.0, 1.2);
        final scale = TextScaler.linear(clampedScale);

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: scale),
          child: child!,
        );
      },
    );
  }
}
