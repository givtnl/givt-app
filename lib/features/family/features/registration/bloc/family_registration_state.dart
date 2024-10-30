part of 'family_registration_bloc.dart';

enum FamilyRegistrationStatus {
  initial,
  loading,
  password,
  personalInfo,
  success,
  failure,
  conflict,
  badRequest,
}

class FamilyRegistrationState extends Equatable {
  const FamilyRegistrationState({
    this.status = FamilyRegistrationStatus.initial,
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.password = '',
  });

  final FamilyRegistrationStatus status;
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  FamilyRegistrationState copyWith({
    FamilyRegistrationStatus? status,
    String? email,
    String? firstName,
    String? lastName,
    String? password,
  }) {
    return FamilyRegistrationState(
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
