sealed class GenerosityStripeRegistrationCustom {
  const GenerosityStripeRegistrationCustom();

  const factory GenerosityStripeRegistrationCustom.openStripeRegistration() =
      OpenStripeRegistration;

  const factory GenerosityStripeRegistrationCustom.openLoginPopup() =
      OpenLoginPopup;

  const factory GenerosityStripeRegistrationCustom.showStripeNoFundsError() =
      ShowStripeNoFundsError;

  const factory GenerosityStripeRegistrationCustom.stripeRegistrationSuccess() =
      StripeRegistrationSuccess;
}

class OpenStripeRegistration extends GenerosityStripeRegistrationCustom {
  const OpenStripeRegistration();
}

class OpenLoginPopup extends GenerosityStripeRegistrationCustom {
  const OpenLoginPopup();
}

class ShowStripeNoFundsError extends GenerosityStripeRegistrationCustom {
  const ShowStripeNoFundsError();
}

class StripeRegistrationSuccess extends GenerosityStripeRegistrationCustom {
  const StripeRegistrationSuccess();
}
