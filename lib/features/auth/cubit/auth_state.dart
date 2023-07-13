part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState({
    this.user = const UserExt.empty(),
  });
  final UserExt user;

  @override
  List<Object> get props => [user];
}

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
  const AuthSuccess({super.user});

  @override
  List<Object> get props => [];
}

class AuthRefreshed extends AuthState {
  const AuthRefreshed({super.user});

  @override
  List<Object> get props => [];
}

class AuthLogout extends AuthState {}

class AuthUnkown extends AuthState {}

class AuthFailure extends AuthState {
  const AuthFailure({this.message = ''});

  final String message;

  @override
  List<Object> get props => [message];
}

class AuthChangePasswordSuccess extends AuthState {
  const AuthChangePasswordSuccess({super.user});

  @override
  List<Object> get props => [];
}

class AuthChangePasswordFailure extends AuthState {
  const AuthChangePasswordFailure({this.message = ''});

  final String message;

  @override
  List<Object> get props => [message];
}

class AuthChangePasswordWrongEmail extends AuthState {
  const AuthChangePasswordWrongEmail(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}
