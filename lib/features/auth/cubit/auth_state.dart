part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

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

class AuthLogout extends AuthState {}

class AuthUnkown extends AuthState {}

class AuthFailure extends AuthState {
  const AuthFailure({this.message = ''});

  final String message;

  @override
  List<Object> get props => [message];
}
