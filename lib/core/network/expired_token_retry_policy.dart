import 'dart:developer';
import 'dart:io' show SocketException;

import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart' show InterceptedClient;
import 'package:http_interceptor/http_interceptor.dart' show InterceptedClient;
import 'package:http_interceptor/models/retry_policy.dart';

/// This is the retry policy that will be used by the [InterceptedClient]
/// to retry requests that failed due to an expired token.
class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  int maxRetryAttempts = 2;

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    ///This is where we need to update our token on 401 response
    if (response.statusCode == 401) {
      return _refreshToken();
    }
    return false;
  }

  /// This method will be called
  /// when a request fails and the [shouldAttemptRetryOnResponse]
  /// Handle the [SocketException] when there is no internet connection
  Future<bool> _refreshToken() async {
    try {
      await getIt<AuthRepository>().refreshToken();
      return true;
    } catch (e) {
      log('No internet connection');
      return false;
    }
  }
}
