import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/features/give/utils/donation_submission_errors.dart';

void main() {
  group('isDonationSubmissionTimeout', () {
    test('returns true for TimeoutException', () {
      expect(isDonationSubmissionTimeout(TimeoutException('timed out')), isTrue);
    });

    test('returns true for HTTP 408 server failure', () {
      expect(
        isDonationSubmissionTimeout(
          const GivtServerFailure(statusCode: 408),
        ),
        isTrue,
      );
    });

    test('returns false for other server failures', () {
      expect(
        isDonationSubmissionTimeout(
          const GivtServerFailure(statusCode: 500),
        ),
        isFalse,
      );
    });

    test('returns false for unrelated errors', () {
      expect(isDonationSubmissionTimeout(Exception('network error')), isFalse);
    });
  });
}
