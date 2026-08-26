import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/auth/models/session.dart';

void main() {
  group('Session.isExpired', () {
    Session sessionWithExpiry(DateTime expiresUtc) {
      return Session(
        email: 'user@example.com',
        userGUID: 'guid',
        accessToken: 'access',
        refreshToken: 'refresh',
        expires: expiresUtc.toIso8601String(),
        expiresIn: 1800,
        isLoggedIn: true,
      );
    }

    test('is true when expires is empty', () {
      expect(const Session.empty().isExpired, isTrue);
    });

    test('is false when expiry is more than two minutes away', () {
      final expires = DateTime.now().toUtc().add(const Duration(minutes: 10));
      expect(sessionWithExpiry(expires).isExpired, isFalse);
    });

    test('is true within two minutes of expiry', () {
      final expires = DateTime.now().toUtc().add(const Duration(minutes: 1));
      expect(sessionWithExpiry(expires).isExpired, isTrue);
    });

    test('uses a two minute refresh buffer', () {
      expect(Session.accessTokenRefreshBuffer, const Duration(minutes: 2));
    });
  });
}
