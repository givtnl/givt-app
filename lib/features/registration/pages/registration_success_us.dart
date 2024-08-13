import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/registration/widgets/registered_check_animation.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class RegistrationSuccessUs extends StatelessWidget {
  const RegistrationSuccessUs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 64),
                  Text(
                    'Registration complete',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Set up your family and experience generosity together.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  const Spacer(),
                  const RegisteredCheckAnimation(),
                  const Spacer(),
                  CustomGreenElevatedButton(
                      title: context.l10n.setUpFamily,
                      onPressed: () {
                        final user = context.read<AuthCubit>().state.user;

                        unawaited(
                          AnalyticsHelper.logEvent(
                            eventName:
                                AmplitudeEvents.registrationSuccesButtonClicked,
                            eventProperties: {
                              'id': user.guid,
                            },
                          ),
                        );
                        context
                          ..pushReplacementNamed(
                              FamilyPages.profileSelection.name,)
                          ..pushNamed(FamilyPages.addMember.name);
                      },),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
