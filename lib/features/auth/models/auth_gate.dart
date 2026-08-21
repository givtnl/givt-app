/// Policy for `AuthUtils.checkToken`.
enum CheckAuthPolicy {
  /// Giving and app-open: keep a valid OAuth session. Face ID only if refresh
  /// fails. No local-auth grace period.
  ensureSession,

  /// Protected menu item taps: Face ID when the local-auth grace period has
  /// elapsed. OAuth refresh only if the access token is actually near expiry.
  stepUp,
}

/// First action `AuthUtils.checkToken` should take for a given policy.
enum AuthGateAction {
  navigate,
  silentRefresh,
  promptBiometrics,
}

/// Pure decision helper for OAuth refresh vs Face ID step-up.
class AuthGate {
  static const Duration localAuthGracePeriod = Duration(minutes: 15);

  static AuthGateAction decide({
    required CheckAuthPolicy policy,
    required bool isAccessTokenExpired,
    required bool isWithinLocalAuthGrace,
    bool needsReauthentication = false,
  }) {
    switch (policy) {
      case CheckAuthPolicy.ensureSession:
        if (needsReauthentication || isAccessTokenExpired) {
          return AuthGateAction.silentRefresh;
        }
        return AuthGateAction.navigate;
      case CheckAuthPolicy.stepUp:
        if (needsReauthentication || !isWithinLocalAuthGrace) {
          return AuthGateAction.promptBiometrics;
        }
        if (isAccessTokenExpired) {
          return AuthGateAction.silentRefresh;
        }
        return AuthGateAction.navigate;
    }
  }
}
