import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/permit_biometric/models/permit_biometric_request.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:go_router/go_router.dart';

class CreditCardDetailsPage extends StatelessWidget {
  const CreditCardDetailsPage({super.key});

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

          final stripe = context.read<StripeCubit>().state.stripeObject;

          Stripe.instance
              .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              merchantDisplayName: 'Givt',
              style: ThemeMode.light,
              billingDetailsCollectionConfiguration:
                  const BillingDetailsCollectionConfiguration(
                address: AddressCollectionMode.never,
                name: CollectionMode.always,
              ),
              customerEphemeralKeySecret: stripe.customerEphemeralKeySecret,
              customerId: stripe.customerId,
              setupIntentClientSecret: stripe.setupIntentClientSecret,
              applePay: const PaymentSheetApplePay(
                merchantCountryCode: 'US',
              ),
              googlePay: const PaymentSheetGooglePay(
                merchantCountryCode: 'US',
                currencyCode: 'USD',
              ),
            ),
          )
              .then((value) async {
            try {
              await Stripe.instance.presentPaymentSheet();

              if (!context.mounted) return;
              context
                  .read<RegistrationBloc>()
                  .add(const RegistrationStripeSuccess());

              context.goNamed(
                Pages.permitBiometric.name,
                extra: PermitBiometricRequest(
                  redirect: (context) => context.goNamed(
                    Pages.registrationSuccessUs.name,
                  ),
                ),
              );
            } on StripeException {
              context.goNamed(Pages.home.name);
            }
          });

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
