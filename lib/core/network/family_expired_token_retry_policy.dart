import 'dart:io';

import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/models/retry_policy.dart';

/// This is the retry policy that will be used by the [InterceptedClient]
/// to retry requests that failed due to an expired token.
class FamilyExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  int maxRetryAttempts = 2;

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    ///This is where we need to update our token on 401 response
    if (response.statusCode == 401) {
      try {
        await _refreshToken();
        return true;
      } catch (e, s) {
        if (e is SocketException) {
          // we failed to refresh the token but the user probably had an internet oopsie, let's retry again
          return true;
        } else {
          // we failed to refresh the token, do not attempt to retry the call
          LoggingInfo.instance.error(e.toString(), methodName: s.toString());
          return false;
        }
      }
    }
    return false;
  }

  Future<void> _refreshToken() async {
    await getIt<FamilyAuthRepository>().refreshToken();
  }
}
