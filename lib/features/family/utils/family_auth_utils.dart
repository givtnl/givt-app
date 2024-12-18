import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/features/login/presentation/pages/family_login_sheet.dart';

class FamilyAuthUtils {
  // A method to authenticate the user with biometrics or email/pass
  // This method is for example used in the ProfileSelectionScreen
  // to authenticate the user before navigating to the Manage Family section
  static Future<void> authenticateUser(
    BuildContext context, {
    required FamilyCheckAuthRequest checkAuthRequest,
  }) async {
    if (!checkAuthRequest.useBiometrics ||
        !await LocalAuthInfo.instance.canCheckBiometrics) {
      LoggingInfo.instance.info(
        'Biometrics not available for family authentication, displaying login sheet',
      );
      if (!context.mounted) {
        return;
      }
      await _displayLoginBottomSheet(
        context,
        checkAuthRequest: checkAuthRequest,
      );
      return;
    }

    try {
      var hasAuthenticated = await LocalAuthInfo.instance.authenticate();

      if (!context.mounted) {
        return;
      }

      if (hasAuthenticated) {
        try {
          await getIt<FamilyAuthCubit>().refreshSession();
        } catch (e) {
          // If the session refresh fails, we want to force the user to log in
          LoggingInfo.instance.error(
            'Error while authenticating, failed to refresh session: $e',
          );
          hasAuthenticated = false;
        }
      }

      if (!context.mounted) {
        return;
      }

      if (!hasAuthenticated) {
        await _displayLoginBottomSheet(
          context,
          checkAuthRequest: checkAuthRequest,
        );
        return;
      }

      await checkAuthRequest.navigate(context);
    } on PlatformException catch (e) {
      LoggingInfo.instance.info(
        'Error while authenticating with biometrics: ${e.message}',
      );
      if (!context.mounted) {
        return;
      }
      await _displayLoginBottomSheet(
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
      await _displayLoginBottomSheet(
        context,
        checkAuthRequest: checkAuthRequest,
      );
    }
  }

  /// Displays the login bottom sheet.
  /// If the user successfully logs in, the [navigate] callback is called.
  /// If the user cancels the login, nothing happens.
  static Future<void> _displayLoginBottomSheet(
    BuildContext context, {
    required FamilyCheckAuthRequest checkAuthRequest,
  }) async {
    final loggedIn = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => FamilyLoginSheet(
        email: checkAuthRequest.email,
        navigate: checkAuthRequest.navigate,
      ),
    );

    if (!context.mounted) return;

    if (loggedIn != null && loggedIn) {
      await checkAuthRequest.navigate(context);
    }
  }
}

class FamilyCheckAuthRequest {
  FamilyCheckAuthRequest({
    required this.navigate,
    this.forceLogin = false,
    this.email,
    this.useBiometrics = true,
  });

  final Future<void> Function(BuildContext context) navigate;
  final bool forceLogin;
  final String? email;
  final bool useBiometrics;
}
