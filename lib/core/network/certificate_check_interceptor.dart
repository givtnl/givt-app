import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:http_interceptor/http_interceptor.dart';

class CertificateCheckInterceptor extends InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final secure = await HttpCertificatePinning.check(
      serverURL: data.baseUrl,
      sha: SHA.SHA256,
      allowedSHAFingerprints: Util.allowedSHAFingerprints,
      timeout: 50,
    );

    if (!secure.contains('CONNECTION_SECURE')) {
      await LoggingInfo.instance.error(
        data.baseUrl,
        methodName: StackTrace.current.toString(),
      );
      throw Exception('CONNECTION_NOT_SECURE');
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}
