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
    if (await getIt<NetworkInfo>().isConnected == false) {
      return request;
    }
    final apiURL = request.url.host;
    // do not check certificate for the certs endpoint
    if (apiURL.contains('certs')) {
      return request;
    }

    final storedSHAFigerprint =
        getIt<SharedPreferences>().getString(apiURL) ?? '';

    final secure = await HttpCertificatePinning.check(
      serverURL: request.url.toString(),
      sha: SHA.SHA256,
      allowedSHAFingerprints: [storedSHAFigerprint],
      timeout: 50,
    );

    if (!secure.contains('CONNECTION_SECURE')) {
      await LoggingInfo.instance.error(
        request.url.toString(),
        methodName: StackTrace.current.toString(),
      );

      throw const CertificatesException(message: 'CONNECTION_NOT_SECURE');
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async =>
      response;
}
