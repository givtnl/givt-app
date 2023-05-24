part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthTempAccountWarning extends AuthState {
  const AuthTempAccountWarning(this.email);
  final String email;

  @override
  List<Object> get props => [email];
}

class AuthLoginRedirect extends AuthState {
  const AuthLoginRedirect(this.email);
  final String email;

  @override
  List<Object> get props => [email];
}

class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);
  final UserExt user;

  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {}
