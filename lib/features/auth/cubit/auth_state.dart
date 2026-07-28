part of 'auth_cubit.dart';

enum AuthStatus {
  loading,
  unknown,
  authenticated,
  unauthenticated,
  noInternet,
  certificateException,
  tempAccountWarning,
  loginRedirect,
  failure,
  changePasswordSuccess,
  changePasswordFailure,
  changePasswordWrongEmail,
  lockedOut,
  twoAttemptsLeft,
  oneAttemptLeft,
  biometricCheck,
  accountDisabled,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user = const UserExt.empty(),
    this.session = const Session.empty(),
    this.presets = const UserPresets.empty(),
    this.email = '',
    this.message = '',
    this.navigate = _emptyNavigate,
    this.needsReauthentication = false,
  });
  final UserExt user;
  final Session session;
  final UserPresets presets;
  final String email;
  final String message;
  final AuthStatus status;
  final Future<void> Function(BuildContext context) navigate;

  /// True when the user is still treated as logged in locally, but the
  /// access/refresh tokens could not be renewed and the UI should prompt
  /// for biometrics or password login.
  final bool needsReauthentication;

  static Future<void> _emptyNavigate(
    BuildContext context,
  ) async {}

  bool get hasNavigation {
    return navigate != _emptyNavigate;
  }

  AuthState copyWith({
    required AuthStatus status,
    UserExt? user,
    Session? session,
    UserPresets? presets,
    String? email,
    String? message,
    Future<void> Function(BuildContext context)? navigate,
    bool? needsReauthentication,
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
      navigate: navigate ?? this.navigate,
      needsReauthentication:
          needsReauthentication ?? this.needsReauthentication,
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
        navigate,
        needsReauthentication,
      ];

  @override
  String toString() {
    return 'AuthState{user: $user, session: $session, email: $email, message: $message, status: $status, presets: $presets, needsReauthentication: $needsReauthentication}';
  }
}
