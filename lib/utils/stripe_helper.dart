import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/shared/models/models.dart';

class StripeHelper {
  StripeHelper(this.context);

  BuildContext context;

  Future<PaymentSheetPaymentOption?> showPaymentSheet({
    StripeResponse? stripe,
  }) async {
    stripe ??= context.read<StripeCubit>().state.stripeObject;
    await Stripe.instance.initPaymentSheet(
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
    );

    return Stripe.instance.presentPaymentSheet();
  }
}
