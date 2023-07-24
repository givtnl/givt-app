import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/pages/login_page.dart';

class AuthUtils {
  static Future<void> checkToken(
    BuildContext context, {
    required VoidCallback navigate,
  }) async {
    final auth = context.read<AuthCubit>();
    final isExpired = auth.state.session.isExpired;
    if (!isExpired) {
      navigate();
      return;
    }
    if (!await LocalAuthInfo.instance.canCheckBiometrics) {
      // ignore: use_build_context_synchronously
      if (!context.mounted) {
        return;
      }
      _passwordLogin(context, navigate: navigate);
      return;
    }
    try {
      final hasAuthenticated = await LocalAuthInfo.instance.authenticate();
      if (!hasAuthenticated) {
        return;
      }
      // ignore: use_build_context_synchronously
      if (!context.mounted) {
        return;
      }
      await context.read<AuthCubit>().refreshSession();
      navigate();
    } on PlatformException catch (e) {
      await LoggingInfo.instance.info(
        'Error while authenticating with biometrics: ${e.message}',
      );
      // ignore: use_build_context_synchronously
      if (!context.mounted) {
        return;
      }
      _passwordLogin(context, navigate: navigate);
    }
  }

  static void _passwordLogin(
    BuildContext context, {
    required VoidCallback navigate,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => LoginPage(
        email: context.read<AuthCubit>().state.user.email,
        popWhenSuccess: true,
      ),
    ).whenComplete(() {
      if (context.read<AuthCubit>().state.session.isExpired) {
        return;
      }
      navigate();
    });
  }
}
