/// Policy for `AuthUtils.checkToken`.
enum CheckAuthPolicy {
  /// Giving and app-open: keep a valid OAuth session. Face ID only if refresh
  /// fails. No local-auth grace period.
  ensureSession,

  /// Protected menu item taps: Face ID when the local-auth grace period has
  /// elapsed. If the access token is expired or reauth is needed, refresh
  /// first so an invalid refresh token can log the user out.
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
        // Refresh first so an invalid refresh token logs the user out
        // instead of prompting Face ID / a dismissible login sheet.
        if (needsReauthentication || isAccessTokenExpired) {
          return AuthGateAction.silentRefresh;
        }
        if (!isWithinLocalAuthGrace) {
          return AuthGateAction.promptBiometrics;
        }
        return AuthGateAction.navigate;
    }
  }
}
