import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/network/token_interceptor.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final sessionJson = jsonEncode({
    'Email': 'user@givt.app',
    'GUID': 'guid-1',
    'access_token': 'access-token',
    'refresh_token': 'refresh-token',
    '.expires': DateTime.now().toUtc().toIso8601String(),
    'isLoggedIn': true,
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({
      Session.tag: sessionJson,
    });
  });

  test('attaches Bearer to /oauth2/token', () async {
    final request = Request(
      'POST',
      Uri.https('dev-backend.givtapp.net', '/oauth2/token'),
    );

    final intercepted = await TokenInterceptor().interceptRequest(
      request: request,
    );

    expect(intercepted.headers['Authorization'], 'Bearer access-token');
  });

  test('attaches Bearer to API requests', () async {
    final request = Request(
      'GET',
      Uri.https('dev-backend.givtapp.net', '/api/v2/UsersExtension/guid-1'),
    );

    final intercepted = await TokenInterceptor().interceptRequest(
      request: request,
    );

    expect(intercepted.headers['Authorization'], 'Bearer access-token');
  });
}
