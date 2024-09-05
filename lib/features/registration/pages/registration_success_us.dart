import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/add_member/pages/add_member_counter_page.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/registration/widgets/registered_check_animation.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class RegistrationSuccessUs extends StatelessWidget {
  const RegistrationSuccessUs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) =>
          context.goNamed(FamilyPages.profileSelection.name),
      child: Theme(
        data: AppTheme.lightTheme,
        child: FunScaffold(
          appBar: FunTopAppBar.primary99(
            title: 'Registration complete',
          ),
          body: Center(
            child: Column(
              children: [
                const Spacer(),
                const RegisteredCheckAnimation(),
                const Spacer(),
                FunButton(
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
                    Navigator.push(
                      context,
                      const AddMemberCounterPage(
                        initialAmount: 1,
                      ).toRoute(context),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
