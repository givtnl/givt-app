part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class RegistrationPasswordSubmitted extends RegistrationEvent {
  const RegistrationPasswordSubmitted({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  final String email;
  final String firstName;
  final String lastName;
  final String password;

  @override
  List<Object> get props => [email, firstName, lastName, password];
}

class RegistrationPersonalInfoSubmitted extends RegistrationEvent {
  const RegistrationPersonalInfoSubmitted({
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.countryCode,
    required this.iban,
    required this.accountNumber,
    required this.sortCode,
    required this.phoneNumber,
    required this.appLanguage,
  });

  final String address;
  final String city;
  final String postalCode;
  final String country;
  final String countryCode;
  final String iban;
  final String accountNumber;
  final String sortCode;
  final String phoneNumber;
  final String appLanguage;

  @override
  List<Object> get props => [
        address,
        city,
        postalCode,
        country,
        countryCode,
        iban,
        accountNumber,
        sortCode,
        phoneNumber,
        appLanguage,
      ];
}

class RegistrationMandateFetchUserExt extends RegistrationEvent {
  const RegistrationMandateFetchUserExt({
    required this.guid,
  });

  final String guid;

  @override
  List<Object> get props => [guid];
}

class RegistrationSignMandate extends RegistrationEvent {
  const RegistrationSignMandate({
    required this.guid,
    required this.appLanguage,
  });

  final String guid;
  final String appLanguage;

  @override
  List<Object> get props => [guid, appLanguage];
}

class RegistrationStripeInit extends RegistrationEvent {
  const RegistrationStripeInit();
}

class RegistrationStripeSuccess extends RegistrationEvent {
  const RegistrationStripeSuccess({
    this.emitAuthenticated = true,
  });

  final bool emitAuthenticated;

  @override
  List<Object> get props => [emitAuthenticated];
}

class RegistrationInit extends RegistrationEvent {
  const RegistrationInit();
}

class RegistrationGiftAidChanged extends RegistrationEvent {
  const RegistrationGiftAidChanged({
    required this.isGiftAidEnabled,
  });

  final bool isGiftAidEnabled;

  @override
  List<Object> get props => [isGiftAidEnabled];
}
