import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/shared/widgets/theme/app_theme_switcher.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

void logout(
  BuildContext context, {
  bool fromLogoutBtn = false,
  bool fromTerminateAccount = false,
}) {
  if (fromTerminateAccount) {
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.terminateAccountSuccess,
    );
  }

  if (fromLogoutBtn) {
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.logoutClicked,
    );
  }

  try {
    context.read<AuthCubit>().logout(fullReset: true);
    getIt<FamilyAuthRepository>().logout();
    context.read<ProfilesCubit>().logout();
    context.read<FlowsCubit>().resetFlow();
    context.read<RegistrationBloc>().add(const RegistrationReset());
    AppThemeSwitcher.of(context).switchTheme(isFamilyApp: false);
  } catch (e) {
    // do nothing, even if logging out fails, from welcome page user can re-login
  }

  context.goNamed(Pages.welcome.name);
}
