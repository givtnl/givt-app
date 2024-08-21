import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_save_key.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/auth/helpers/logout_helper.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_secondary_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/shared/widgets/family_scaffold.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void _goToChallenge(BuildContext context, UserExt user) {
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.goToChallengeFromRegistrationClicked,
    );
    final email = user.email;
    getIt<SharedPreferences>().setString(
      ChatScriptSaveKey.email.value,
      email,
    );
    context.goNamed(FamilyPages.generosityChallenge.name);
  }

  @override
  Widget build(BuildContext context) {
    final theme = const FamilyAppTheme().toThemeData();
    final user = context.read<AuthCubit>().state.user;

    return FamilyScaffold(
      appBar: AppBar(
        leading: GenerosityBackButton(
          onPressed: () {
            logout(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Join the Generosity Challenge!',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          familySuperheroesIcon(),
          const Padding(
            padding: EdgeInsets.all(8),
            child: BodyMediumText(
              'Help your city by spreading generosity!',
              textAlign: TextAlign.center,
            ),
          ),
          _buildButtons(context, user),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, UserExt user) => Column(
        children: [
          GivtElevatedButton(
            onTap: () => _goToChallenge(context, user),
            leftIcon: FontAwesomeIcons.trophy,
            text: 'Go to Challenge',
          ),
          const SizedBox(height: 8),
          GivtElevatedSecondaryButton(
            onTap: () => _navigate(context, user),
            text: 'Register without Challenge',
          ),
        ],
      );
}
