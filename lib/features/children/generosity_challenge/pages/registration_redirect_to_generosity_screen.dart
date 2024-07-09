import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/auth/helpers/logout_helper.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_elevated_secondary_button.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class RegistrationRedirectToGenerosityScreen extends StatefulWidget {
  const RegistrationRedirectToGenerosityScreen({super.key});

  @override
  State<RegistrationRedirectToGenerosityScreen> createState() =>
      _RegistrationRedirectToGenerosityScreenState();
}

class _RegistrationRedirectToGenerosityScreenState
    extends State<RegistrationRedirectToGenerosityScreen> {
  void _navigate(BuildContext context, UserExt user) {
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.registerWithoutChallengeClicked,
    );

    context.pushNamed(
      FamilyPages.registrationUS.name,
      queryParameters: {
        'email': user.email,
        'createStripe': user.personalInfoRegistered.toString(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = const FamilyAppTheme().toThemeData();
    final user = context.read<AuthCubit>().state.user;

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          leading: GivtBackButton(
            onPressedForced: () {
              logout(context);
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Join the Generosity Challenge!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
                familySuperheroesIcon(),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Help your city by spreading generosity!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                _buildButtons(context, user),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context, UserExt user) => Column(
        children: [
          GivtElevatedButton(
            onTap: () {
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.goToChallengeFromRegistrationClicked,
              );
              context.goNamed(FamilyPages.generosityChallenge.name);
            },
            leftIcon: FontAwesomeIcons.trophy,
            text: 'Go to Challenge',
          ),
          const SizedBox(height: 8),
          GivtElevatedSecondaryButton(
            onTap: () => _navigate(context, user),
            text: 'Register without Challenge',
          ),
          const SizedBox(height: 8),
        ],
      );
}
