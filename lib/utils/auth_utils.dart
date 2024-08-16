import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/pages/login_page.dart';
import 'package:givt_app/features/family/features/auth/pages/family_login_page.dart';

class CheckAuthRequest {
  CheckAuthRequest({
    required this.navigate,
    this.email = '',
    this.isUSUser = false,
    this.forceLogin = false,
  });

  final Future<void> Function(BuildContext context, {bool? isUSUser}) navigate;
  final String email;
  final bool isUSUser;
  final bool forceLogin;
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
      await _displayLoginBottomSheet(
        context,
        checkAuthRequest: checkAuthRequest,
      );
      return;
    }

    final auth = context.read<AuthCubit>();
    final isExpired = auth.state.session.isExpired;
    if (!isExpired) {
      await checkAuthRequest.navigate(context);
      return;
    }
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
      if (!hasAuthenticated) {
        return;
      }
      if (!context.mounted) {
        return;
      }
      await context.read<AuthCubit>().refreshSession();
      if (!context.mounted) {
        return;
      }
      await checkAuthRequest.navigate(
        context,
        isUSUser: auth.state.user.isUsUser,
      );
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
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        if (checkAuthRequest.isUSUser) {
          return FamilyLoginPage(
            email: checkAuthRequest.email.isNotEmpty
                ? checkAuthRequest.email
                : context.read<AuthCubit>().state.user.email,
            navigate: checkAuthRequest.navigate,
          );
        } else {
          return LoginPage(
            email: checkAuthRequest.email.isNotEmpty
                ? checkAuthRequest.email
                : context.read<AuthCubit>().state.user.email,
            isEmailEditable: checkAuthRequest.email.isNotEmpty,
            navigate: checkAuthRequest.navigate,
          );
        }
      },
    );
  }
}
