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

    test('fromHttpResponse accepts an empty body', () {
      final failure = GivtServerFailure.fromHttpResponse(
        statusCode: 401,
        body: '',
      );

      expect(failure.body, isNull);
      expect(failure.isInvalidGrant, isFalse);
      expect(failure.isRejectedOAuthToken, isTrue);
    });

    test('isRejectedOAuthToken is true for 400 without JSON error', () {
      const failure = GivtServerFailure(statusCode: 400);

      expect(failure.isRejectedOAuthToken, isTrue);
    });

    test('isRejectedOAuthToken is false for server errors', () {
      const failure = GivtServerFailure(statusCode: 500);

      expect(failure.isRejectedOAuthToken, isFalse);
    });

    test('toString includes statusCode and body', () {
      const failure = GivtServerFailure(
        statusCode: 401,
        body: {'error': 'invalid_grant'},
      );

      expect(
        failure.toString(),
        'GivtServerFailure(statusCode: 401, body: {error: invalid_grant})',
      );
    });
  });

  group('GivtServerFailure mandate already signed', () {
    test('is true when 409 message contains the code', () {
      const failure = GivtServerFailure(
        statusCode: 409,
        body: {'errorMessage': 'MANDATE_ALREADY_SIGNED: closed.completed'},
      );

      expect(failure.isMandateAlreadySigned, isTrue);
      expect(
        failure.userFacingMessage,
        'MANDATE_ALREADY_SIGNED: closed.completed',
      );
    });

    test('is false for other 409s', () {
      const failure = GivtServerFailure(
        statusCode: 409,
        body: {'errorMessage': 'duplicate'},
      );

      expect(failure.isMandateAlreadySigned, isFalse);
    });
  });
}
