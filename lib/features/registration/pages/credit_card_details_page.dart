import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/permit_biometric/models/permit_biometric_request.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/stripe_helper.dart';
import 'package:go_router/go_router.dart';

class CreditCardDetailsPage extends StatelessWidget {
  const CreditCardDetailsPage({
    this.onRegistrationSuccess,
    this.onRegistrationFailed,
    super.key,
  });

  final void Function()? onRegistrationSuccess;
  final void Function()? onRegistrationFailed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StripeCubit, StripeState>(
        builder: (_, state) {
          if (state.stripeStatus == StripeObjectStatus.initial) {
            context.read<StripeCubit>().fetchSetupIntent();
            return const Center(child: CircularProgressIndicator());
          }
          if (state.stripeStatus == StripeObjectStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.stripeStatus == StripeObjectStatus.failure) {
            return const Center(child: Text('Could not connect to Stripe'));
          }

          if (state.stripeStatus != StripeObjectStatus.display) {
            return const Center(child: CircularProgressIndicator());
          }

          StripeHelper(context).showPaymentSheet().then((value) {
            if (onRegistrationSuccess != null) {
              context.pop();
              onRegistrationSuccess!.call();
            } else {
              _handleStripeRegistrationSuccess(context);
              final user = context.read<AuthCubit>().state.user;
              AnalyticsHelper.setUserProperties(
                userId: user.guid,
              );
              unawaited(
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.registrationStripeSheetFilled,
                  eventProperties: AnalyticsHelper.getUserPropertiesFromExt(
                    user,
                  ),
                ),
              );
            }
          }).onError((e, stackTrace) {
            if (onRegistrationFailed != null) {
              context.pop();
              onRegistrationFailed!.call();
            } else {
              context.pop();
              final user = context.read<AuthCubit>().state.user;

              unawaited(
                AnalyticsHelper.logEvent(
                  eventName:
                      AmplitudeEvents.registrationStripeSheetIncompleteClosed,
                  eventProperties: {
                    'id': user.guid,
                    'profile_country': user.country,
                  },
                ),
              );
              context.read<ProfilesCubit>().fetchAllProfiles(doChecks: true);
            }

            /* Logged as info as stripe is giving exception
               when for example people close the bottomsheet. 
               So it's not a real error :)
            */
            LoggingInfo.instance.info(
              e.toString(),
              methodName: stackTrace.toString(),
            );
          });

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _handleStripeRegistrationSuccess(BuildContext context) {
    context.read<RegistrationBloc>().add(const RegistrationStripeSuccess());

    context.pushReplacementNamed(
      FamilyPages.permitUSBiometric.name,
      extra: PermitBiometricRequest.registration(redirect: (context) {
        context
          ..pushReplacementNamed(FamilyPages.profileSelection.name)
          ..pushNamed(FamilyPages.registrationSuccessUs.name);
      }),
    );
  }
}
