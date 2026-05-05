import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/creditcard_setup/cubit/stripe_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/errors/retry_error_widget.dart';
import 'package:givt_app/features/family/shared/widgets/loading/full_screen_loading_widget.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/stripe_helper.dart';

/// Stripe payment sheet during US registration (EU shell).
class CreditCardDetails extends StatefulWidget {
  const CreditCardDetails({
    required this.parentContext,
    required this.onSuccess,
    this.shrink = false,
    super.key,
  });

  /// Host route context (below this modal) for presenting Stripe after dismiss.
  final BuildContext parentContext;

  final bool shrink;
  final VoidCallback onSuccess;

  @override
  State<CreditCardDetails> createState() => _CreditCardDetailsState();

  static void show(
    BuildContext context, {
    required VoidCallback onSuccess,
    bool shrink = true,
  }) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (modalContext) => CreditCardDetails(
        parentContext: context,
        shrink: shrink,
        onSuccess: onSuccess,
      ),
    );
  }
}

class _CreditCardDetailsState extends State<CreditCardDetails> {
  bool showPaymentSheet = false;

  @override
  void initState() {
    super.initState();
    // Defer fetch until after first frame so the route is stable.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_fetchSetupIntentThenPresentSheet());
      }
    });
  }

  Future<void> _fetchSetupIntentThenPresentSheet() async {
    await getIt<StripeCubit>().fetchSetupIntent();
    if (!mounted) return;
    await _presentStripeSheetIfReady();
  }

  Future<void> _presentStripeSheetIfReady() async {
    if (!mounted || showPaymentSheet) return;
    final stripeState = getIt<StripeCubit>().state;
    if (stripeState.stripeStatus != StripeObjectStatus.display) return;

    setState(() {
      showPaymentSheet = true;
    });

    try {
      final parent = widget.parentContext;
      await StripeHelper(context).prepareSetupPaymentSheet();
      if (!mounted) return;
      if (!parent.mounted) return;

      Navigator.of(context, rootNavigator: true).pop();
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (!parent.mounted) return;

      await StripeHelper(parent).presentSetupPaymentSheet();
      if (!parent.mounted) return;
      _handleStripeRegistrationSuccess(parent);
      final user = parent.read<AuthCubit>().state.user;
      unawaited(
        AnalyticsHelper.setUserProperties(
          userId: user.guid,
        ),
      );
      unawaited(
        AnalyticsHelper.logEvent(
          eventName: AnalyticsEventName.registrationStripeSheetFilled,
          eventProperties: AnalyticsHelper.getUserPropertiesFromExt(
            user,
          ),
        ),
      );
    } on Object catch (e, stackTrace) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      final parent = widget.parentContext;
      if (!parent.mounted) return;
      final user = parent.read<AuthCubit>().state.user;

      unawaited(
        AnalyticsHelper.logEvent(
          eventName: AnalyticsEventName.registrationStripeSheetIncompleteClosed,
          eventProperties: {
            'id': user.guid,
            'profile_country': user.country,
          },
        ),
      );

      LoggingInfo.instance.info(
        e.toString(),
        methodName: stackTrace.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StripeCubit, StripeState>(
      bloc: getIt<StripeCubit>(),
      builder: (_, state) {
        if (state.stripeStatus == StripeObjectStatus.failure) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: RetryErrorWidget(
              onTapPrimaryButton: () =>
                  unawaited(_fetchSetupIntentThenPresentSheet()),
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
      },
    );
  }

  void _handleStripeRegistrationSuccess(BuildContext context) {
    context.read<RegistrationBloc>().add(const RegistrationStripeSuccess());
  }
}
