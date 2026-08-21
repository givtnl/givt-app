import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/models/auth_gate.dart';
import 'package:givt_app/features/auth/pages/login_page.dart';

export 'package:givt_app/features/auth/models/auth_gate.dart';

class CheckAuthRequest {
  CheckAuthRequest({
    required this.navigate,
    this.email = '',
    this.forceLogin = false,
    this.allowWhenOffline = false,
    this.policy = CheckAuthPolicy.ensureSession,
  });

  final Future<void> Function(BuildContext context) navigate;
  final String email;
  final bool forceLogin;

  /// When true (giving flows only), continue with the local session if the
  /// device is offline instead of prompting for login. Other destinations
  /// must leave this false so they never navigate without a refreshed token.
  final bool allowWhenOffline;

  /// Giving / app-open use [CheckAuthPolicy.ensureSession]. Protected menu
  /// item taps use [CheckAuthPolicy.stepUp].
  final CheckAuthPolicy policy;
}

class AuthUtils {
  /// Checks if the user is authenticated.
  /// If the user is authenticated, the [navigate] callback is called.
  /// If the user is not authenticated, the login bottom sheet is displayed
  /// or the biometrics are checked.
  static Future<void> checkToken(
    BuildContext context, {
    required CheckAuthRequest checkAuthRequest,
  }) async {
    if (checkAuthRequest.forceLogin) {
      LoggingInfo.instance.info(
        'Check token request is forced, displaying login bottom sheet.',
      );
      await displayLoginBottomSheet(
        context,
        checkAuthRequest: checkAuthRequest,
      );
      return;
    }

    if (_canSkipRefreshForOfflineGiving(
      context,
      checkAuthRequest: checkAuthRequest,
    )) {
      LoggingInfo.instance.info(
        'Offline giving: skipping session refresh, '
        'continuing with local session.',
      );
      await checkAuthRequest.navigate(context);
      return;
    }

    final authCubit = context.read<AuthCubit>();
    final action = AuthGate.decide(
      policy: checkAuthRequest.policy,
      isAccessTokenExpired: authCubit.state.session.isExpired,
      isWithinLocalAuthGrace: authCubit.isWithinLocalAuthGrace,
      needsReauthentication: authCubit.state.needsReauthentication,
    );

    switch (action) {
      case AuthGateAction.navigate:
        await checkAuthRequest.navigate(context);
        return;
      case AuthGateAction.silentRefresh:
        final forceRefresh = authCubit.state.needsReauthentication;
        final refreshResult = await authCubit.refreshSession(
          emitAuthentication: false,
          force: forceRefresh,
        );
        if (!context.mounted) {
          return;
        }
        if (await _tryNavigateAfterRefresh(
          context,
          checkAuthRequest: checkAuthRequest,
          refreshResult: refreshResult,
        )) {
          return;
        }
        if (!context.mounted) {
          return;
        }
        await _promptBiometricsOrLogin(
          context,
          checkAuthRequest: checkAuthRequest,
        );
        return;
      case AuthGateAction.promptBiometrics:
        await _promptBiometricsOrLogin(
          context,
          checkAuthRequest: checkAuthRequest,
        );
        return;
    }
  }

  static bool _canSkipRefreshForOfflineGiving(
    BuildContext context, {
    required CheckAuthRequest checkAuthRequest,
  }) {
    if (!checkAuthRequest.allowWhenOffline) {
      return false;
    }
    if (getIt<NetworkInfo>().isConnected) {
      return false;
    }
    return _hasLocalAuthenticatedSession(context.read<AuthCubit>().state);
  }

  static bool _hasLocalAuthenticatedSession(AuthState auth) {
    return auth.user.guid.isNotEmpty &&
        auth.status != AuthStatus.unauthenticated;
  }

  /// Returns true when [navigate] was invoked and the caller should stop.
  static Future<bool> _tryNavigateAfterRefresh(
    BuildContext context, {
    required CheckAuthRequest checkAuthRequest,
    required RefreshSessionResult refreshResult,
  }) async {
    switch (refreshResult) {
      case RefreshSessionResult.success:
        await checkAuthRequest.navigate(context);
        return true;
      case RefreshSessionResult.offline:
        if (checkAuthRequest.allowWhenOffline &&
            _hasLocalAuthenticatedSession(context.read<AuthCubit>().state)) {
          LoggingInfo.instance.info(
            'Offline giving: session refresh failed due to no network, '
            'continuing with local session.',
          );
          await checkAuthRequest.navigate(context);
          return true;
        }
        return false;
      case RefreshSessionResult.failure:
        return false;
    }
  }

  static Future<void> _promptBiometricsOrLogin(
    BuildContext context, {
    required CheckAuthRequest checkAuthRequest,
  }) async {
    if (!await LocalAuthInfo.instance.canCheckBiometrics) {
      if (!context.mounted) {
        return;
      }
      LoggingInfo.instance.info(
        'Session refresh failed, biometrics not available, displaying login bottom sheet.',
      );
      await displayLoginBottomSheet(
        context,
        checkAuthRequest: checkAuthRequest,
      );
      return;
    }
    try {
      final hasAuthenticated = await LocalAuthInfo.instance.authenticate();
      if (!hasAuthenticated) {
        if (!context.mounted) {
          return;
        }
        await displayLoginBottomSheet(
          context,
          checkAuthRequest: checkAuthRequest,
        );
        return;
      }
      if (!context.mounted) {
        return;
      }
      context.read<AuthCubit>().markLocalAuthSucceeded();
      final refreshResult = await context.read<AuthCubit>().refreshSession(
        emitAuthentication: false,
      );
      if (!context.mounted) {
        return;
      }
      if (await _tryNavigateAfterRefresh(
        context,
        checkAuthRequest: checkAuthRequest,
        refreshResult: refreshResult,
      )) {
        return;
      }
      if (!context.mounted) {
        return;
      }
      await displayLoginBottomSheet(
        context,
        checkAuthRequest: checkAuthRequest,
      );
    } on PlatformException catch (e) {
      LoggingInfo.instance.info(
        'Error while authenticating with biometrics: ${e.message}',
      );
      if (!context.mounted) {
        return;
      }
      await displayLoginBottomSheet(
        context,
        checkAuthRequest: checkAuthRequest,
      );
    } catch (e) {
      LoggingInfo.instance.error(
        'Error while authenticating with biometrics: $e',
      );
      if (!context.mounted) {
        return;
      }
      await displayLoginBottomSheet(
        context,
        checkAuthRequest: checkAuthRequest,
      );
    }
  }

  /// Displays the login bottom sheet.
  /// If the user successfully logs in, the [navigate] callback is called.
  /// If the user cancels the login, nothing happens.
  static Future<void> displayLoginBottomSheet(
    BuildContext context, {
    required CheckAuthRequest checkAuthRequest,
  }) async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return LoginPage(
          email: checkAuthRequest.email.isNotEmpty
              ? checkAuthRequest.email
              : sheetContext.read<AuthCubit>().state.user.email,
          isEmailEditable: checkAuthRequest.email.isNotEmpty,
          navigate: checkAuthRequest.navigate,
        );
      },
    );
  }
}
