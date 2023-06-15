part of 'registration_bloc.dart';

enum RegistrationStatus {
  initial,
  loading,
  password,
  personalInfo,
  mandateExplanation,
  sepaMandate,
  bacsDirectDebitMandate,
  success,
  failure,
}

class RegistrationState extends Equatable {
  const RegistrationState({
    this.status = RegistrationStatus.initial,
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.password = '',
    this.registeredUser = const UserExt.empty(),
  });

  final RegistrationStatus status;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final UserExt registeredUser;

  RegistrationState copyWith({
    RegistrationStatus? status,
    String? email,
    String? firstName,
    String? lastName,
    String? password,
    UserExt? registeredUser,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      registeredUser: registeredUser ?? this.registeredUser,
    );
  }

  @override
  List<Object> get props => [
        status,
        email,
        firstName,
        lastName,
        password,
        registeredUser,
      ];
}
