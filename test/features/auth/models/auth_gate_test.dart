import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/auth/models/auth_gate.dart';

void main() {
  group('AuthGate.decide ensureSession', () {
    test('navigates when access token is still valid', () {
      expect(
        AuthGate.decide(
          policy: CheckAuthPolicy.ensureSession,
          isAccessTokenExpired: false,
          isWithinLocalAuthGrace: false,
        ),
        AuthGateAction.navigate,
      );
    });

    test('silently refreshes when access token is expired', () {
      expect(
        AuthGate.decide(
          policy: CheckAuthPolicy.ensureSession,
          isAccessTokenExpired: true,
          isWithinLocalAuthGrace: true,
        ),
        AuthGateAction.silentRefresh,
      );
    });

    test('silently refreshes when startup reauth is needed', () {
      expect(
        AuthGate.decide(
          policy: CheckAuthPolicy.ensureSession,
          isAccessTokenExpired: false,
          isWithinLocalAuthGrace: true,
          needsReauthentication: true,
        ),
        AuthGateAction.silentRefresh,
      );
    });
  });

  group('AuthGate.decide stepUp', () {
    test('prompts biometrics when local-auth grace has elapsed', () {
      expect(
        AuthGate.decide(
          policy: CheckAuthPolicy.stepUp,
          isAccessTokenExpired: false,
          isWithinLocalAuthGrace: false,
        ),
        AuthGateAction.promptBiometrics,
      );
    });

    test(
      'silently refreshes when reauthentication is needed even within grace',
      () {
        expect(
          AuthGate.decide(
            policy: CheckAuthPolicy.stepUp,
            isAccessTokenExpired: false,
            isWithinLocalAuthGrace: true,
            needsReauthentication: true,
          ),
          AuthGateAction.silentRefresh,
        );
      },
    );

    test('navigates when within grace and access token is valid', () {
      expect(
        AuthGate.decide(
          policy: CheckAuthPolicy.stepUp,
          isAccessTokenExpired: false,
          isWithinLocalAuthGrace: true,
        ),
        AuthGateAction.navigate,
      );
    });

    test('silently refreshes when within grace and token is expired', () {
      expect(
        AuthGate.decide(
          policy: CheckAuthPolicy.stepUp,
          isAccessTokenExpired: true,
          isWithinLocalAuthGrace: true,
        ),
        AuthGateAction.silentRefresh,
      );
    });

    test('uses a 15 minute local-auth grace period', () {
      expect(AuthGate.localAuthGracePeriod, const Duration(minutes: 15));
    });
  });
}
