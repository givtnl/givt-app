import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/login/presentation/pages/family_login_sheet.dart';

class FamilyAuthUtils {
  // A method to authenticate the user with biometrics or email/pass
  // This method is for example used in the ProfileSelectionScreen
  // to authenticate the user before navigating to the Manage Family section
  static Future<void> authenticateUser(
    BuildContext context, {
    required CheckAuthRequest checkAuthRequest,
  }) async {
    if (!await LocalAuthInfo.instance.canCheckBiometrics) {
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
      final hasAuthenticated = await LocalAuthInfo.instance.authenticate();
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

      await context.read<AuthCubit>().refreshSession();
      if (!context.mounted) {
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
    required CheckAuthRequest checkAuthRequest,
  }) async {
    final loggedIn = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => FamilyLoginSheet(
        email: context.read<AuthCubit>().state.user.email,
        navigate: checkAuthRequest.navigate,
      ),
    );

    if (!context.mounted) return;

    if (loggedIn != null && loggedIn) {
      await checkAuthRequest.navigate(context);
    }
  }
}

class CheckAuthRequest {
  CheckAuthRequest({
    required this.navigate,
    this.forceLogin = false,
  });

  final Future<void> Function(BuildContext context, {bool? isUSUser}) navigate;
  final bool forceLogin;
}
