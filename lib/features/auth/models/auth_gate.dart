/// Policy for `AuthUtils.checkToken`.
enum CheckAuthPolicy {
  /// Giving and app-open: keep a valid OAuth session. Face ID only if
  /// refresh fails for a recoverable reason. No local-auth grace period.
  /// An invalid refresh token logs the user out instead of Face ID/login.
  ensureSession,

  /// Protected menu item taps: Face ID when the 15-minute local-auth grace
  /// has elapsed. If the access token is expired or reauth is needed,
  /// refresh first so an invalid refresh token logs the user out before
  /// Face ID (opening the menu must not Face ID-scan a dead session).
  stepUp,
}

/// First action `AuthUtils.checkToken` should take for a given policy.
enum AuthGateAction {
  /// Session is usable; continue without Face ID or login.
  navigate,

  /// Refresh the OAuth session before navigating or prompting Face ID.
  silentRefresh,

  /// Prompt Face ID (then login sheet if biometrics fail). Never used
  /// when the refresh token is already known to be invalid.
  promptBiometrics,
}

/// Pure decision helper for OAuth refresh vs Face ID step-up.
///
/// Decision order for [CheckAuthPolicy.stepUp]:
/// 1. Expired access token or `needsReauthentication` → silent refresh
///    (invalid grant logs out; no Face ID).
/// 2. Local-auth grace elapsed → Face ID.
/// 3. Otherwise navigate.
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
