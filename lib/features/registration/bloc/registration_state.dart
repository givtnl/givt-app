part of 'registration_bloc.dart';

enum RegistrationStatus {
  initial,
  loading,
  password,
  personalInfo,
  sepaMandateExplanation,
  sepaMandate,
  confirmPaymentDetails,
  finalizingAccount,
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
    this.errorMessage = '',
  });

  final RegistrationStatus status;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String errorMessage;

  RegistrationState copyWith({
    RegistrationStatus? status,
    String? email,
    String? firstName,
    String? lastName,
    String? password,
    String? errorMessage,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    status,
    email,
    firstName,
    lastName,
    password,
    errorMessage,
  ];
}
