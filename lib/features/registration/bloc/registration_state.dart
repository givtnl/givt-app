part of 'registration_bloc.dart';

enum RegistrationStatus {
  initial,
  loading,
  password,
  personalInfo,
  sepaMandateExplanation,
  sepaMandate,
  bacsDirectDebitMandateExplanation,
  bacsDirectDebitMandate,
  success,
  bacsDirectDebitMandateSigned,
  giftAidChanged,
  failure,
  conflict,
  badRequest,
  ddiFailed,
  bacsDetailsWrong,
}

class RegistrationState extends Equatable {
  const RegistrationState({
    this.status = RegistrationStatus.initial,
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.password = '',
  });

  final RegistrationStatus status;
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  RegistrationState copyWith({
    RegistrationStatus? status,
    String? email,
    String? firstName,
    String? lastName,
    String? password,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
    
    );
  }

  @override
  List<Object> get props => [
        status,
        email,
        firstName,
        lastName,
        password,
      ];
}
