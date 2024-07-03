import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/shared/widgets/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app/features/family/shared/widgets/givt_elevated_secondary_button.dart';
import 'package:givt_app/features/family/utils/utils.dart';
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
  @override
  Widget build(BuildContext context) {
    final theme = const FamilyAppTheme().toThemeData();
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          leading: GivtBackButtonFlat(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                _buildButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) => Column(
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
            onTap: () {
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.registerWithoutChallengeClicked,
              );
              context.pop();
            },
            text: 'Register without Challenge',
          ),
          const SizedBox(height: 8),
        ],
      );
}
