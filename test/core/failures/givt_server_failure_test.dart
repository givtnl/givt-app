import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/failures/failures.dart';

void main() {
  group('GivtServerFailure.isInvalidGrant', () {
    test('is true when OAuth error is invalid_grant', () {
      const failure = GivtServerFailure(
        statusCode: 400,
        body: {'error': 'invalid_grant'},
      );

      expect(failure.isInvalidGrant, isTrue);
    });

    test('is false for other OAuth errors', () {
      const failure = GivtServerFailure(
        statusCode: 400,
        body: {'error': 'invalid_client'},
      );

      expect(failure.isInvalidGrant, isFalse);
    });

    test('is false when body is missing', () {
      const failure = GivtServerFailure(statusCode: 500);

      expect(failure.isInvalidGrant, isFalse);
    });
  });
}
