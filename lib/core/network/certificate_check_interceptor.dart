import 'dart:io';

import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:http_interceptor/http_interceptor.dart';

class CertificateCheckInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    return request;
    // if (Platform.isIOS) {
    //   return request;
    // }

    // /// Don't check for certificate if there is no internet connection
    // if (await getIt<NetworkInfo>().isConnected == false) {
    //   return request;
    // }

    // final secure = await HttpCertificatePinning.check(
    //   serverURL: request.url.toString(),
    //   sha: SHA.SHA256,
    //   allowedSHAFingerprints: Util.allowedSHAFingerprints,
    //   timeout: 50,
    //   index: 2,
    // );

    // if (!secure.contains('CONNECTION_SECURE')) {
    //   await LoggingInfo.instance.error(
    //     request.url.toString(),
    //     methodName: StackTrace.current.toString(),
    //   );
    //   throw Exception('CONNECTION_NOT_SECURE');
    // }
    // return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async =>
      response;
}
