import 'package:flutter/services.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CertificateCheckInterceptor extends InterceptorContract {
  CertificateCheckInterceptor();

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    /// Don't check for certificate if there is no internet connection
    if (getIt<NetworkInfo>().isConnected == false) {
      return request;
    }

    final apiURL = request.url.host;
    // do not check certificate for the certs endpoint
    if (apiURL.contains('certs')) {
      return request;
    }

    final host = request.url.host;
    final storedSHAFigerprint =
        getIt<SharedPreferences>().getString(apiURL) ?? '';

    try {
      final secure = await HttpCertificatePinning.check(
        serverURL: request.url.toString(),
        sha: SHA.SHA256,
        allowedSHAFingerprints: [storedSHAFigerprint],
        timeout: 50,
      );
      if (!secure.contains('CONNECTION_SECURE')) {
        LoggingInfo.instance.error(
          'Certificate pinning check failed: host=$host '
          'requestUrl=${request.url} pluginResult=$secure '
          'storedFingerprintLength=${storedSHAFigerprint.length} '
          'sharedPrefsKeyHost=$apiURL',
          methodName: StackTrace.current.toString(),
        );

        throw const CertificatesException(message: 'CONNECTION_NOT_SECURE');
      }
    } on PlatformException catch (e, s) {
      LoggingInfo.instance.error(
        'Certificate pinning PlatformException: host=$host '
        'code=${e.code} message=${e.message} '
        'storedFingerprintLength=${storedSHAFigerprint.length}',
        methodName: s.toString(),
      );
      if (e.code == 'CONNECTION_NOT_SECURE') {
        throw const CertificatesException(message: 'CONNECTION_NOT_SECURE');
      }
      rethrow;
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async => response;
}
