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