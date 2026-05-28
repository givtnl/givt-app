import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
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
      eventName: AnalyticsEventName.terminateAccountSuccess,
    );
  }

  if (fromLogoutBtn) {
    AnalyticsHelper.logEvent(
      eventName: AnalyticsEventName.logoutClicked,
    );
  }

  try {
    getIt<FamilyAuthRepository>().logout();
  } on Object catch (_) {
    // Family session may be absent when using EU shell only.
  }
  try {
    context.read<RegistrationBloc>().add(const RegistrationReset());
  } on Object catch (_) {
    // Registration bloc may not be in this subtree.
  }
  context.read<AuthCubit>().logout(fullReset: true);
  AppThemeSwitcher.of(context).switchTheme(isFamilyApp: false);

  context.goNamed(Pages.welcome.name);
}
