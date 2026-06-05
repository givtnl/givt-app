import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/loading/full_screen_loading_widget.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/review_donations/utils/navigation_helper.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

/// Full-screen loading shown while the backend finishes US account setup
/// after Stripe payment details are saved.
class RegistrationAccountSetupPage extends StatelessWidget {
  const RegistrationAccountSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state.status == RegistrationStatus.success) {
          unawaited(
            navigateAfterMandateSigning(
              context,
              context.read<AuthCubit>().state.user.country,
            ),
          );
        }
        if (state.status == RegistrationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(locals.registrationErrorTitle),
            ),
          );
          context.goNamed(
            Pages.registrationPaymentConfirm.name,
            extra: context.read<RegistrationBloc>(),
          );
        }
      },
      child: FullScreenLoadingWidget(
        text: locals.registrationAccountSetupMessage,
      ),
    );
  }
}
