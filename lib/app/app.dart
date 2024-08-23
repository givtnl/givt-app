import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/app_router.dart';
import 'package:givt_app/core/notification/notification.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app/features/family/features/impact_groups/cubit/impact_groups_cubit.dart'
    as FamilyImpactGroupsCubit;
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app/features/family/features/topup/cubit/topup_cubit.dart';
import 'package:givt_app/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
import 'package:givt_app/shared/widgets/theme/app_theme_switcher.dart';
import 'package:givt_app/utils/utils.dart';

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

    AnalyticsHelper.init(const String.fromEnvironment('AMPLITUDE_KEY'));

    initializeStripe();
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
          BlocProvider<ProfilesCubit>(
            create: (BuildContext context) =>
                ProfilesCubit(getIt(), getIt(), getIt()),
          ),
          BlocProvider(
            create: (context) => TopupCubit(getIt()),
          ),
          BlocProvider<OrganisationDetailsCubit>(
            create: (BuildContext context) => OrganisationDetailsCubit(getIt()),
          ),
          BlocProvider<FlowsCubit>(
            create: (BuildContext context) => FlowsCubit(),
          ),
          BlocProvider<FamilyImpactGroupsCubit.ImpactGroupsCubit>(
            create: (BuildContext context) =>
                FamilyImpactGroupsCubit.ImpactGroupsCubit(getIt()),
          ),
          BlocProvider(
            create: (context) => ScanNfcCubit(),
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
          builder: (BuildContext context, ThemeData themeData,
              {required bool isFamilyApp,}) {
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
  }

  Future<void> resetAppBadge() async {
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      await FlutterAppBadger.removeBadge();
    }
  }
}

class _AppView extends StatelessWidget {
  const _AppView({required this.themeData});

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: themeData,
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
