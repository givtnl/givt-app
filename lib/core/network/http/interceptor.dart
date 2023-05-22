import 'dart:developer';

import 'package:http_interceptor/http_interceptor.dart';

class Interceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      ///TODO add token to request

      /// If there is no content type, we set it to application/json
      if (!data.headers.containsKey('Content-Type')) {
        data.headers['Content-Type'] = 'application/json';
      }
      data.headers['Accept'] = 'application/json';
    } catch (e) {
      log(e.toString());
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}

/// This is the retry policy that will be used by the [InterceptedClient]
/// to retry requests that failed due to an expired token.
class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  int maxRetryAttempts = 2;

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    ///This is where we need to update our token on 401 response
    if (response.statusCode == 401) {
      ///todo add here refresh token method from repository
      return true;
    }
    return false;
  }
}
