part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {
  const RegistrationInitial();

  @override
  List<Object> get props => [];
}

class RegistrationLoading extends RegistrationState {
  const RegistrationLoading();

  @override
  List<Object> get props => [];
}

class RegistrationPassword extends RegistrationState {
  const RegistrationPassword({
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
