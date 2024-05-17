import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_stripe_registration_custom.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_striple_registration_cubit.dart';
import 'package:givt_app/features/children/shared/presentation/widgets/no_funds_error_dialog.dart';
import 'package:givt_app/features/children/shared/presentation/widgets/no_funds_initial_dialog.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/features/registration/pages/credit_card_details_page.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/utils/auth_utils.dart';
import 'package:givt_app/utils/stripe_helper.dart';

class GenerosityStripeRegistrationPage extends StatefulWidget {
  const GenerosityStripeRegistrationPage({
    super.key,
    this.onRegistrationSuccess,
    this.onRegistrationFailed,
    this.onBackPressed,
  });

  final void Function()? onRegistrationSuccess;
  final void Function()? onRegistrationFailed;
  final void Function()? onBackPressed;

  @override
  State<GenerosityStripeRegistrationPage> createState() =>
      _GenerosityStripeRegistrationPageState();
}

class _GenerosityStripeRegistrationPageState
    extends State<GenerosityStripeRegistrationPage> {
  final GenerosityStripeRegistrationCubit _cubit =
      getIt<GenerosityStripeRegistrationCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) => widget.onBackPressed?.call(),
      canPop: widget.onBackPressed == null,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: const [BackButton()],
        ),
        body: BaseStateConsumer(
          onCustom: (context, custom) => _handleCustom(
              context, custom as GenerosityStripeRegistrationCustom),
          onData: (context, uiModel) {
            //TODO
            return NoFundsInitialDialog(
              onClickContinue: _cubit.onClickContinueInitiallyNoFunds,
            );
          },
          bloc: _cubit,
        ),
      ),
    );
  }

  void _handleCustom(
      BuildContext context, GenerosityStripeRegistrationCustom custom) {
    switch (custom) {
      case final OpenStripeRegistration stripeRegistration:
        _showStripeRegistrationSheet(context, stripeRegistration);
      case StripeRegistrationSuccess():
        widget.onRegistrationSuccess?.call();
      case ShowStripeNoFundsError():
        NoFundsErrorDialog.show(context, onClickContinue: _cubit.onClickRetry);
      case ShowSetupError():
      // TODO: Handle this case.
    }
  }

  void _showStripeRegistrationSheet(BuildContext context, OpenStripeRegistration stripeRegistration) {
    StripeHelper(context)
        .showPaymentSheet(stripe: stripeRegistration.stripeResponse)
        .then((value) {
      _cubit.onRegistrationSuccess();
    }).onError((e, stackTrace) {
      _cubit.onRegistrationFailed();

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
}
