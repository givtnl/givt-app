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
    this.presets = const UserPresets.empty(),
    this.email = '',
    this.message = '',
  });
  final UserExt user;
  final Session session;
  final UserPresets presets;
  final String email;
  final String message;
  final AuthStatus status;

  AuthState copyWith({
    required AuthStatus status,
    UserExt? user,
    Session? session,
    UserPresets? presets,
    String? email,
    String? message,
  }) {
    if (status == AuthStatus.authenticated) {
      email = '';
      message = '';
    }
    return AuthState(
      user: user ?? this.user,
      session: session ?? this.session,
      email: email ?? this.email,
      message: message ?? this.message,
      status: status,
      presets: presets ?? this.presets,
    );
  }

  @override
  List<Object> get props => [
        user,
        session,
        email,
        message,
        status,
        presets,
      ];
}
