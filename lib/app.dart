import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/first_use/pages/welcome_page.dart';
import 'package:givt_app/features/give/pages/home_page.dart';
import 'package:givt_app/injection.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/splash_screen.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';

class App extends StatefulWidget {
  const App({
    required this.config,
    super.key,
  });

  final Map<String, String> config;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    FlutterSimCountryCode.simCountryCode.then((countryIso) {
      getIt<APIService>().apiURL = countryIso == 'US'
          ? widget.config['API_URL_US']!
          : widget.config['API_URL_EU']!;
    }).catchError((e) {
      getIt<APIService>().apiURL = widget.config['API_URL_EU']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    AnalyticsHelper.init(widget.config['AMPLITUDE_KEY']!);

    return BlocProvider(
      create: (_) => AuthCubit(getIt())..checkAuth(),
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  NavigatorState get _navigator => Util.navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorKey: Util.navigatorKey,
      onGenerateRoute: (_) => SpalshPage.route(),
      builder: (context, child) {
        return BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              _navigator.pushAndRemoveUntil<void>(
                HomePage.route(),
                (route) => false,
              );
              return;
            }
            if (state is AuthLogout || state is AuthUnkown) {
              _navigator.pushAndRemoveUntil<void>(
                WelcomePage.route(),
                (route) => false,
              );
            }
          },
          child: child,
        );
      },
    );
  }
}
