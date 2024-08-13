import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TokenInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final correlationId = const Uuid().v4();

    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionString = prefs.getString(Session.tag);

      if (!request.headers.containsKey('Content-Type')) {
        request.headers['Content-Type'] = 'application/json';
      }

      request.headers['Accept'] = 'application/json';
      request.headers['Correlation-Id'] = correlationId;

      if (sessionString == null) {
        return request;
      }

      final session = Session.fromJson(
        jsonDecode(sessionString) as Map<String, dynamic>,
      );

      if (session.accessToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer ${session.accessToken}';
      }
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
    }

    unawaited(
      LoggingInfo.instance.logRequest(
        'API - ${request.method}',
        request.url.toString(),
        correlationId,
      ),
    );

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async =>
      response;

  @override
  Future<bool> shouldInterceptRequest() => Future.value(true);

  @override
  Future<bool> shouldInterceptResponse() => Future.value(true);
}

/// This is the retry policy that will be used by the [InterceptedClient]
/// to retry requests that failed due to an expired token.
class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  int maxRetryAttempts = 2;

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    ///This is where we need to update our token on 401 response
    if (response.statusCode == 401) {
      await _refreshToken();
      return true;
    }
    return false;
  }

  /// This method will be called
  /// when a request fails and the [shouldAttemptRetryOnResponse]
  /// Handle the [SocketException] when there is no internet connection
  Future<void> _refreshToken() async {
    try {
      await getIt<AuthRepository>().refreshToken();
    } catch (e) {
      log('No internet connection');
    }
  }
}
