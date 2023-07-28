import 'dart:convert';
import 'dart:developer';

import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionString = prefs.getString(Session.tag);

      if (!data.headers.containsKey('Content-Type')) {
        data.headers['Content-Type'] = 'application/json';
      }
      data.headers['Accept'] = 'application/json';

      if (sessionString == null) {
        return data;
      }

      final session = Session.fromJson(
        jsonDecode(sessionString) as Map<String, dynamic>,
      );

      if (session.accessToken.isNotEmpty) {
        data.headers['Authorization'] = 'Bearer ${session.accessToken}';
      }
    } catch (e) {
      log(e.toString());
    }
    await LoggingInfo.instance.error(
      '${data.method}: ${data.baseUrl}${data.params}',
      methodName: StackTrace.current.toString(),
    );
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
      await getIt<AuthRepositoy>().refreshToken();
      return true;
    }
    return false;
  }
}
