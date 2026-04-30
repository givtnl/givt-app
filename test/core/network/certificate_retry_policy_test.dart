import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/failures/certificate_exception.dart';
import 'package:givt_app/core/network/certificate_retry_policy.dart';
import 'package:http/http.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:http_interceptor/models/retry_policy.dart';

class _FixedTokenPolicy extends RetryPolicy {
  @override
  int get maxRetryAttempts => 2;

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async =>
      false;
}

void main() {
  group('CompositeRetryCertificateWithTokenPolicy', () {
    test(
      'refreshes fingerprints once then refuses same request instance',
      () async {
        var refreshCount = 0;
        final policy = CompositeRetryCertificateWithTokenPolicy(
          tokenRetryPolicy: _FixedTokenPolicy(),
          onRefreshFingerprints: () async {
            refreshCount++;
          },
        );

        expect(policy.maxRetryAttempts, 3);

        final req = Request('GET', Uri.parse('https://api.example.com/path'));

        expect(
          await policy.shouldAttemptRetryOnException(
            const CertificatesException(message: 'CONNECTION_NOT_SECURE'),
            req,
          ),
          true,
        );
        expect(refreshCount, 1);

        expect(
          await policy.shouldAttemptRetryOnException(
            const CertificatesException(message: 'CONNECTION_NOT_SECURE'),
            req,
          ),
          false,
        );
        expect(refreshCount, 1);
      },
    );

    test('shouldAttemptRetryOnResponse resets same-request guard', () async {
      var refreshCount = 0;
      final policy = CompositeRetryCertificateWithTokenPolicy(
        tokenRetryPolicy: _FixedTokenPolicy(),
        onRefreshFingerprints: () async {
          refreshCount++;
        },
      );
      final req = Request('GET', Uri.parse('https://api.example.com/path'));

      expect(
        await policy.shouldAttemptRetryOnException(
          const CertificatesException(message: 'CONNECTION_NOT_SECURE'),
          req,
        ),
        true,
      );

      await policy.shouldAttemptRetryOnResponse(
        Response('ok', 200, request: req),
      );

      expect(
        await policy.shouldAttemptRetryOnException(
          const CertificatesException(message: 'CONNECTION_NOT_SECURE'),
          req,
        ),
        true,
      );
      expect(refreshCount, 2);
    });

    test('isCertificateFailure', () {
      expect(
        CompositeRetryCertificateWithTokenPolicy.isCertificateFailure(
          const CertificatesException(message: 'CONNECTION_NOT_SECURE'),
        ),
        true,
      );
      expect(
        CompositeRetryCertificateWithTokenPolicy.isCertificateFailure(
          const CertificateNotVerifiedException(),
        ),
        true,
      );
      expect(
        CompositeRetryCertificateWithTokenPolicy.isCertificateFailure(
          const FormatException('unrelated'),
        ),
        false,
      );
    });

    test('delegates token retry on response', () async {
      var tokenChecked = false;
      final tokenPolicy = _TokenPolicyThatAlwaysRetries(
        onCalled: () => tokenChecked = true,
      );
      final policy = CompositeRetryCertificateWithTokenPolicy(
        tokenRetryPolicy: tokenPolicy,
        onRefreshFingerprints: () async {},
      );

      final req = Request('GET', Uri.parse('https://api.example.com/path'));
      expect(
        await policy.shouldAttemptRetryOnResponse(
          Response('unauth', 401, request: req),
        ),
        true,
      );
      expect(tokenChecked, true);
    });
  });
}

class _TokenPolicyThatAlwaysRetries extends RetryPolicy {
  _TokenPolicyThatAlwaysRetries({required this.onCalled});

  final void Function() onCalled;

  @override
  int get maxRetryAttempts => 1;

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    onCalled();
    return response.statusCode == 401;
  }
}
