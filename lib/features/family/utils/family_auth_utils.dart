import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/auth/pages/family_login_page.dart';

class FamilyAuthUtils {
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
      await checkAuthRequest.navigate(context);
    } on PlatformException catch (e) {
      await LoggingInfo.instance.info(
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
      await LoggingInfo.instance.error(
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
      builder: (_) => FamilyLoginPage(
        email: context.read<AuthCubit>().state.user.email,
        navigate: checkAuthRequest.navigate,
      ),
    );
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
