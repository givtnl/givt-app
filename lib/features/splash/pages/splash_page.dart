import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/splash/cubit/splash_cubit.dart';
import 'package:givt_app/features/splash/cubit/splash_custom.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/organisation/organisation_bloc.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashCubit _cubit = getIt<SplashCubit>();

  bool _showNoInternetMessage = false;
  bool _showCurrentlyExperiencingIssues = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      unawaited(_cubit.init());
      var country = Country.nl;
      final prefs = await SharedPreferences.getInstance();
      final userExtString = prefs.getString(UserExt.tag);
      if (userExtString != null) {
        try {
          final user =
              UserExt.fromJson(jsonDecode(userExtString) as Map<String, dynamic>);
          country = Country.fromCode(user.country);
        } on Object catch (_) {
          country = Country.nl;
        }
      }
      if (!mounted) return;
      getIt<OrganisationBloc>().add(
        OrganisationFetch(
          country,
          type: CollectGroupType.none.index,
        ),
      );
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onLoading: (context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 100,
            ),
            const SizedBox(height: 20),
            const CustomCircularProgressIndicator(),
            if (_showNoInternetMessage)
              Padding(
                padding: const EdgeInsets.all(20),
                child: BodyMediumText(
                  context.l10n.noInternet,
                  textAlign: TextAlign.center,
                ),
              ),
            if (_showCurrentlyExperiencingIssues)
              const Padding(
                padding: EdgeInsets.all(20),
                child: BodyMediumText(
                  'We are currently experiencing issues with connecting to the server. We will automatically keep retrying. Feel free to close the app and try again later.',
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
      onCustom: handleCustom,
    );
  }

  void handleCustom(BuildContext context, SplashCustom state) {
    switch (state) {
      case SplashRedirectToWelcome():
        context.goNamed(Pages.welcome.name);
      case NoInternet():
        setState(() {
          _showNoInternetMessage = true;
          _showCurrentlyExperiencingIssues = false;
        });
      case ExperiencingIssues():
        setState(() {
          _showCurrentlyExperiencingIssues = true;
          _showNoInternetMessage = false;
        });
      case SplashRedirectToEmailSignup():
        context.goNamed(
          Pages.welcome.name,
          queryParameters: {'email': state.email},
        );
    }
  }
}
