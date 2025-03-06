import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/permit_biometric/models/permit_biometric_request.dart';
import 'package:givt_app/features/splash/cubit/splash_cubit.dart';
import 'package:givt_app/features/splash/cubit/splash_custom.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/organisation/organisation_bloc.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/utils/add_member_util.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _cubit = getIt<SplashCubit>();

  bool _showNoInternetMessage = false;
  bool _showCurrentlyExperiencingIssues = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.init();
      getIt<OrganisationBloc>().add(
        OrganisationFetch(
          Country.fromCode(Country.us.countryCode),
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
            if (!_showCurrentlyExperiencingIssues)
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
                  'We are currently experiencing issues. Please close the app and try again later.',
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
      case SplashRedirectToSignup():
        context.goNamed(
          FamilyPages.registrationUS.name,
          queryParameters: {'email': state.email},
        );
      case SplashRedirectToUSHome():
        context.goNamed(FamilyPages.profileSelection.name);
      case SplashRedirectToAddMembers():
        context.pushReplacementNamed(
          FamilyPages.permitUSBiometric.name,
          extra: PermitBiometricRequest.registration(
            redirect: AddMemberUtil.addFamilyPushPages,
          ),
        );
      case NoInternet():
        setState(() {
          _showNoInternetMessage = true;
        });
      case ExperiencingIssues():
        setState(() {
          _showCurrentlyExperiencingIssues = true;
        });
      case SplashRedirectToEUHome():
        context.goNamed(Pages.home.name);
    }
  }
}
