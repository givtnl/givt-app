part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState({
    this.user = const UserExt.empty(),
    this.session = const Session.empty(),
    this.email = '',
  });
  final UserExt user;
  final Session session;
  final String email;

  @override
  List<Object> get props => [user, session, email];
}

class AuthLoading extends AuthState {}

class AuthTempAccountWarning extends AuthState {
  const AuthTempAccountWarning({super.email});

  @override
  List<Object> get props => [];
}

class AuthLoginRedirect extends AuthState {
  const AuthLoginRedirect({super.email});

  @override
  List<Object> get props => [];
}

class AuthSuccess extends AuthState {
  const AuthSuccess({
    super.user,
    super.session,
  });

  @override
  List<Object> get props => [];
}

class AuthRefreshed extends AuthState {
  const AuthRefreshed({
    super.user,
    super.session,
  });

  @override
  List<Object> get props => [];
}

class AuthLogout extends AuthState {
  const AuthLogout({
    super.email,
  });

  @override
  List<Object> get props => [];
}

class AuthUnkown extends AuthState {
  const AuthUnkown({
    super.email,
  });

  @override
  List<Object> get props => [];
}

class AuthFailure extends AuthState {
  const AuthFailure({
    this.message = '',
    super.session,
    super.user,
  });

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
  const AuthChangePasswordWrongEmail({super.email});

  @override
  List<Object> get props => [];
}
