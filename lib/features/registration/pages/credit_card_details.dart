import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_bar_home_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/errors/retry_error_widget.dart';
import 'package:givt_app/features/family/shared/widgets/loading/full_screen_loading_widget.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/stripe_helper.dart';
import 'package:go_router/go_router.dart';

class CreditCardDetails extends StatefulWidget {
  const CreditCardDetails({
    this.shrink = false,
    super.key,
  });

  final bool shrink;

  @override
  State<CreditCardDetails> createState() => _CreditCardDetailsState();

  static void show(
    BuildContext context, {
    bool shrink = true,
    VoidCallback? onClose,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) => CreditCardDetails(
        shrink: shrink,
      ),
    ).then((value) {
      onClose?.call();
    });
  }
}

class _CreditCardDetailsState extends State<CreditCardDetails> {
  bool showPaymentSheet = false;

  @override
  void initState() {
    super.initState();
    getIt<StripeCubit>().fetchSetupIntent();
    context.read<RegistrationBloc>().add(const RegistrationInit());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state.status == RegistrationStatus.success) {
            context.pop();
          }
        },
        child: BlocConsumer<StripeCubit, StripeState>(
            bloc: getIt<StripeCubit>(),
            listener: (context, state) {
              if (state.stripeStatus == StripeObjectStatus.display &&
                  !showPaymentSheet) {
                setState(() {
                  showPaymentSheet = true;
                });
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
                      eventName: AmplitudeEvents
                          .registrationStripeSheetIncompleteClosed,
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
              }
            },
            builder: (_, state) {
              if (state.stripeStatus == StripeObjectStatus.failure) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: RetryErrorWidget(
                    onTapPrimaryButton: () =>
                        getIt<StripeCubit>().fetchSetupIntent(),
                  ),
                );
              }

              return SizedBox(
                height: widget.shrink
                    ? MediaQuery.of(context).size.height * 0.5
                    : null,
                child: const FullScreenLoadingWidget(
                  text: 'Hold on, we are saving your card details...',
                ),
              );
            }));
  }

  void _handleStripeRegistrationSuccess(BuildContext context) {
    context.read<RegistrationBloc>().add(const RegistrationStripeSuccess());
  }
}
