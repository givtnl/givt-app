import 'dart:async';
import 'dart:convert';

import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/models/session.dart';
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
