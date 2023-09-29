part of 'auth_cubit.dart';

enum AuthStatus {
  loading,
  unknown,
  authenticated,
  unauthenticated,
  noInternet,
  tempAccountWarning,
  loginRedirect,
  failure,
  changePasswordSuccess,
  changePasswordFailure,
  changePasswordWrongEmail,
  lockedOut,
  twoAttemptsLeft,
  oneAttemptLeft,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user = const UserExt.empty(),
    this.session = const Session.empty(),
    this.email = '',
    this.message = '',
  });
  final UserExt user;
  final Session session;
  final String email;
  final String message;
  final AuthStatus status;

  AuthState copyWith({
    required AuthStatus status,
    UserExt? user,
    Session? session,
    String? email,
    String? message,
  }) {
    if (status == AuthStatus.authenticated) {
      email = '';
      message = '';
    }
    if (status == AuthStatus.unauthenticated) {
      user = const UserExt.empty();
      session = const Session.empty();
    }
    return AuthState(
      user: user ?? this.user,
      session: session ?? this.session,
      email: email ?? this.email,
      message: message ?? this.message,
      status: status,
    );
  }

  @override
  List<Object> get props => [
        user,
        session,
        email,
        message,
        status,
      ];
}
