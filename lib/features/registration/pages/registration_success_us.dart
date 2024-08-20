import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/registration/widgets/registered_check_animation.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/family_scaffold.dart';
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
      child: FamilyScaffold(
        appBar: const GenerosityAppBar(
          title: 'Registration complete',
          leading: null,
        ),
        body: Center(
          child: Column(
            children: [
              const Spacer(),
              const RegisteredCheckAnimation(),
              const Spacer(),
              GivtElevatedButton(
                text: context.l10n.setUpFamily,
                onTap: () {
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
                      FamilyPages.profileSelection.name,
                    )
                    ..pushNamed(FamilyPages.addMember.name);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
