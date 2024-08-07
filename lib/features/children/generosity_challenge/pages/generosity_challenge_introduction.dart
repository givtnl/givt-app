import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/registration/widgets/acceptPolicyRow.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerosityChallengeIntroduction extends StatefulWidget {
  const GenerosityChallengeIntroduction({
    super.key,
  });

  @override
  State<GenerosityChallengeIntroduction> createState() =>
      _GenerosityChallengeIntroductionState();
}

class _GenerosityChallengeIntroductionState
    extends State<GenerosityChallengeIntroduction> {
  bool _acceptPolicy = false;
  final AppConfig _appConfig = getIt();

  @override
  Widget build(BuildContext context) {
    const pictureHeight = 150.0;
    final isAuthenticatedUser =
        context.read<AuthCubit>().state.status == AuthStatus.authenticated;
    return Scaffold(
      appBar: GenerosityAppBar(
        title: 'Generosity Challenge',
        leading: isAuthenticatedUser
            ? GenerosityBackButton(
                onPressed: () =>
                    context.goNamed(FamilyPages.profileSelection.name),
              )
            : null,
      ),
      backgroundColor: AppTheme.givtLightBackgroundGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: pictureHeight - 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: AppTheme.tertiary90,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi Superheroes!',
                          style: purpleCardTextStyle?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Thanks for reading my letter and for coming to the rescue. \n \nAre you ready to accept the challenge to spread generosity?',
                          style: purpleCardTextStyle?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '— The Mayor of Tulsa',
                    style: purpleCardTextStyle?.copyWith(
                      color: AppTheme.givtGreen40,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              SvgPicture.asset(
                'assets/images/mayor.svg',
                height: pictureHeight,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: AppTheme.givtLightBackgroundGreen,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AcceptPolicyRow(
              onTap: (value) {
                setState(() {
                  _acceptPolicy = value!;
                });
              },
              checkBoxValue: _acceptPolicy,
            ),
            GivtElevatedButton(
              isDisabled: !_acceptPolicy,
              onTap: () {
                GenerosityChallengeHelper.activate(
                  isDebug: _appConfig.isTestApp,
                );
                getIt<SharedPreferences>().remove(
                  GenerosityChallengeHelper
                      .generosityChallengewasRegisteredBeforeChallengeKey,
                );
                context.pop();
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.acceptedGenerosityChallenge,
                );
                context.goNamed(
                  FamilyPages.generosityChallengeChat.name,
                  extra: context.read<GenerosityChallengeCubit>(),
                );
              },
              text: 'Accept the challenge',
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  TextStyle? get purpleCardTextStyle =>
      AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
        fontSize: 20,
        color: AppTheme.tertiary20,
        fontFamily: 'Rouna',
      );
}
