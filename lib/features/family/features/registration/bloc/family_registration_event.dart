part of 'family_registration_bloc.dart';

abstract class FamilyRegistrationEvent extends Equatable {
  const FamilyRegistrationEvent();

  @override
  List<Object> get props => [];
}

class FamilyPersonalInfoSubmitted extends FamilyRegistrationEvent {
  const FamilyPersonalInfoSubmitted({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.country,
    required this.countryCode,
    required this.phoneNumber,
    required this.appLanguage,
    this.profilePicture = '',
  });

  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String country;
  final String countryCode;
  final String phoneNumber;
  final String appLanguage;
  final String profilePicture;

  @override
  List<Object> get props => [
        email,
        firstName,
        lastName,
        password,
        country,
        countryCode,
        phoneNumber,
        appLanguage,
        profilePicture,
      ];
}

class FamilyRegistrationInit extends FamilyRegistrationEvent {
  const FamilyRegistrationInit();
}

class FamilyRegistrationReset extends FamilyRegistrationEvent {
  const FamilyRegistrationReset();
}
