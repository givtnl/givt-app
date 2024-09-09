import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/registration/widgets/registered_check_animation.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
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
                    context.pushReplacementNamed(
                      FamilyPages.profileSelection.name,
                    );
                  },
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.registrationSuccesButtonClicked,
                    parameters: {
                      'id': context.read<AuthCubit>().state.user.guid,
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
