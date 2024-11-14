import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/children/utils/add_member_util.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/splash/cubit/splash_cubit.dart';
import 'package:givt_app/features/splash/cubit/splash_custom.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.init();
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
      case SplashRedirectToHome():
        context.goNamed(FamilyPages.profileSelection.name);
      case SplashRedirectToAddMembers():
        AddMemberUtil.addFamilyPushPages(context);
    }
  }
}
