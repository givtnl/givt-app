import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/features/creditcard_setup/cubit/stripe_cubit.dart';
import 'package:givt_app/shared/models/models.dart';

class StripeHelper {
  StripeHelper(this.context);

  BuildContext context;

  /// Initializes the Payment Sheet for the current setup intent.
  Future<void> prepareSetupPaymentSheet({
    StripeResponse? stripe,
  }) async {
    stripe ??= getIt<StripeCubit>().state.stripeObject;
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
  }

  /// Presents the native sheet.
  /// Prefer a [BuildContext] with no other modal route on top.
  Future<PaymentSheetPaymentOption?> presentSetupPaymentSheet() async {
    return Stripe.instance.presentPaymentSheet().timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        throw TimeoutException(
          'Stripe presentPaymentSheet timed out after 20 seconds',
        );
      },
    );
  }

  /// Prepare then present (e.g. account edit, no stacked modal).
  Future<PaymentSheetPaymentOption?> showPaymentSheet({
    StripeResponse? stripe,
  }) async {
    await prepareSetupPaymentSheet(stripe: stripe);
    return presentSetupPaymentSheet();
  }
}
