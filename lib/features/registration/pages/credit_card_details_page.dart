import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_bar_home_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/errors/retry_error_widget.dart';
import 'package:givt_app/features/family/shared/widgets/loading/full_screen_loading_widget.dart';
import 'package:givt_app/features/permit_biometric/models/permit_biometric_request.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/stripe_helper.dart';
import 'package:go_router/go_router.dart';

class CreditCardDetails extends StatelessWidget {
  const CreditCardDetails({
    this.shrink = false,
    super.key,
  });
  final bool shrink;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StripeCubit, StripeState>(
      bloc: getIt<StripeCubit>(),
      builder: (_, state) {
        if (state.stripeStatus == StripeObjectStatus.initial) {
          getIt<StripeCubit>().fetchSetupIntent();
          return shrink ? const SizedBox() : const FullScreenLoadingWidget();
        }

        if (state.stripeStatus == StripeObjectStatus.failure) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: RetryErrorWidget(
              onTapPrimaryButton: () => getIt<StripeCubit>().fetchSetupIntent(),
            ),
          );
        }

        StripeHelper(context).showPaymentSheet().then((value) {
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
        }).onError((e, stackTrace) {
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
          getIt<NavigationBarHomeCubit>().refreshData();

          /* Logged as info as stripe is giving exception
               when for example people close the bottomsheet.
               So it's not a real error :)
            */
          LoggingInfo.instance.info(
            e.toString(),
            methodName: stackTrace.toString(),
          );
        });

        return shrink ? const SizedBox() : const FullScreenLoadingWidget();
      },
    );
  }

  void _handleStripeRegistrationSuccess(BuildContext context) {
    context
        .read<RegistrationBloc>()
        .add(const RegistrationStripeSuccess(emitAuthenticated: false));
    context.pushReplacementNamed(
      FamilyPages.permitUSBiometric.name,
      extra: PermitBiometricRequest.registration(
        redirect: (context) {
          context.pushReplacementNamed(FamilyPages.registrationSuccessUs.name);
        },
      ),
    );
  }

  static void show(BuildContext context, {bool shrink = false}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) => CreditCardDetails(shrink: shrink),
    );
  }
}
