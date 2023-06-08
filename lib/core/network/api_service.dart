import 'dart:convert';
import 'dart:io';

import 'package:givt_app/core/network/interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class APIService {
  APIService() {
    apiURL = 'givt-debug-api.azurewebsites.net';
  }
  Client client = InterceptedClient.build(
    interceptors: [
      Interceptor(),
    ],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );

  late String apiURL;

  Future<dynamic> checkEmailExists(String email) async {
    final url = Uri.https(
      apiURL,
      '/api/v2/Users/check',
      {'email': email},
    );
    final response = await client.get(url);
    if (response.statusCode >= 400) {
      throw Exception('Failed to check email');
    } else {
      return response.body;
    }
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> body) async {
    final url = Uri.https(apiURL, '/oauth2/token');
    final response = await client.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      encoding: Encoding.getByName('utf-8'),
    );
    if (response.statusCode >= 400) {
      throw Exception(jsonDecode(response.body));
    } else {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  Future<Map<String, dynamic>> refreshToken(Map<String, dynamic> body) async {
    final url = Uri.https(apiURL, '/oauth2/token');
    final response = await client.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      encoding: Encoding.getByName('utf-8'),
    );
    if (response.statusCode >= 400) {
      throw Exception('something went wrong :(');
    } else {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  Future<Map<String, dynamic>> getUserExtension(String guid) async {
    final url = Uri.https(apiURL, '/api/v2/UsersExtension/$guid');
    final response = await client.get(url);
    if (response.statusCode >= 400) {
      throw Exception('something went wrong :(');
    } else {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  Future<bool> checktld(String email) async {
    final url = Uri.https(apiURL, '/api/checktld', {'email': email});
    final body = (await client.get(url)).body;
    return jsonDecode(body) as String == 'true';
  }

  Future<String> checkEmail(String email) async {
    final url = Uri.https(apiURL, '/api/v2/Users/check', {'email': email});
    return (await client.get(url)).body;
  }

  Future<String> registerTempUser(Map<String, dynamic> body) async {
    final url = Uri.https(apiURL, '/api/v2/users');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(body),
    );
    if (response.statusCode >= 400) {
      throw HttpException(response.body);
    }
    return response.body;
  }

  Future<Map<String, dynamic>> getOrganisationDetailsFromMedium(
    Map<String, dynamic> params,
  ) async {
    final url = Uri.https(
      apiURL,
      '/api/v3/campaigns',
      params,
    );
    final response = await client.get(url);
    if (response.statusCode >= 400) {
      throw Exception('something went wrong :(');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getCollectGroupList() {
    final url = Uri.https(apiURL, '/api/v2/CollectGroups/applist');
    return client.get(url).then((response) {
      if (response.statusCode >= 400) {
        throw Exception('something went wrong :(');
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    });
  }

  Future<bool> submitGivts({
    required Map<String, dynamic> body,
    required String guid,
  }) async {
    final url = Uri.https(apiURL, '/api/v2/users/$guid/givts');
    return client
        .post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(body),
    )
        .then((response) {
      if (response.statusCode >= 400) {
        throw Exception('something went wrong :(');
      }
      return response.statusCode == 200;
    });
  }
}
