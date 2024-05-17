import 'package:givt_app/shared/models/models.dart';

sealed class GenerosityStripeRegistrationCustom {
  const GenerosityStripeRegistrationCustom();

  const factory GenerosityStripeRegistrationCustom.openStripeRegistration(
      StripeResponse stripeResponse) = OpenStripeRegistration;

  const factory GenerosityStripeRegistrationCustom.showStripeNoFundsError() =
      ShowStripeNoFundsError;

  const factory GenerosityStripeRegistrationCustom.showSetupError() =
      ShowSetupError;

  const factory GenerosityStripeRegistrationCustom.stripeRegistrationSuccess() =
      StripeRegistrationSuccess;
}

class OpenStripeRegistration extends GenerosityStripeRegistrationCustom {
  const OpenStripeRegistration(this.stripeResponse);

  final StripeResponse stripeResponse;
}

class ShowStripeNoFundsError extends GenerosityStripeRegistrationCustom {
  const ShowStripeNoFundsError();
}

class ShowSetupError extends GenerosityStripeRegistrationCustom {
  const ShowSetupError();
}

class StripeRegistrationSuccess extends GenerosityStripeRegistrationCustom {
  const StripeRegistrationSuccess();
}
