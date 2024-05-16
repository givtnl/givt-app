import 'package:flutter/material.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_striple_registration_cubit.dart';
import 'package:givt_app/features/registration/pages/credit_card_details_page.dart';

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
      GenerosityStripeRegistrationCubit();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) => widget.onBackPressed?.call(),
      canPop: widget.onBackPressed == null,
      child: CreditCardDetailsPage(
        onRegistrationFailed: _cubit.onRegistrationFailed,
        onRegistrationSuccess: widget.onRegistrationSuccess,
      ),
    );
  }
}
