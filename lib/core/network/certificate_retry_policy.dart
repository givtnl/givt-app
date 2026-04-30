import 'package:flutter/services.dart';
import 'package:givt_app/core/failures/certificate_exception.dart';
import 'package:http/http.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:http_interceptor/models/retry_policy.dart';

/// On certificate pinning failure, invokes the refresh callback once per failed
/// request, then delegates HTTP response retries (for example token refresh)
/// to the wrapped token retry policy.
class CompositeRetryCertificateWithTokenPolicy extends RetryPolicy {
  CompositeRetryCertificateWithTokenPolicy({
    required RetryPolicy tokenRetryPolicy,
    required Future<void> Function() onRefreshFingerprints,
  }) : _token = tokenRetryPolicy,
       _onRefreshFingerprints = onRefreshFingerprints;

  final RetryPolicy _token;
  final Future<void> Function() _onRefreshFingerprints;

  BaseRequest? _lastRefreshedRequest;

  @override
  int get maxRetryAttempts => _token.maxRetryAttempts + 1;

  static bool isCertificateFailure(Exception reason) {
    if (reason is CertificatesException) return true;
    if (reason is CertificateNotVerifiedException) return true;
    if (reason is PlatformException && reason.code == 'CONNECTION_NOT_SECURE') {
      return true;
    }
    final message = reason.toString();
    return message.contains('CONNECTION_NOT_SECURE') ||
        message.contains('CertificateNotVerifiedException');
  }

  @override
  Future<bool> shouldAttemptRetryOnException(
    Exception reason,
    BaseRequest request,
  ) async {
    if (!isCertificateFailure(reason)) {
      return false;
    }
    if (identical(_lastRefreshedRequest, request)) {
      return false;
    }
    _lastRefreshedRequest = request;
    await _onRefreshFingerprints();
    return true;
  }

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    _lastRefreshedRequest = null;
    return _token.shouldAttemptRetryOnResponse(response);
  }

  @override
  Duration delayRetryAttemptOnException({required int retryAttempt}) =>
      _token.delayRetryAttemptOnException(retryAttempt: retryAttempt);

  @override
  Duration delayRetryAttemptOnResponse({required int retryAttempt}) =>
      _token.delayRetryAttemptOnResponse(retryAttempt: retryAttempt);
}
