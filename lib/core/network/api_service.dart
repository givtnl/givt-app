import 'dart:convert';
import 'dart:io';

import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/network/interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class APIService {
  APIService({
    required String apiURL,
  }) : _apiURL = apiURL;

  Client client = InterceptedClient.build(
    requestTimeout: const Duration(seconds: 10),
    interceptors: [
      Interceptor(),
    ],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );

  final String _apiURL;

  String get apiURL => _apiURL;

  Future<Map<String, dynamic>> login(Map<String, dynamic> body) async {
    final url = Uri.https(_apiURL, '/oauth2/token');
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
    final url = Uri.https(_apiURL, '/oauth2/token');
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
    final url = Uri.https(_apiURL, '/api/v2/UsersExtension/$guid');
    final response = await client.get(url);
    if (response.statusCode >= 400) {
      throw Exception('something went wrong :(');
    } else {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  Future<bool> checktld(String email) async {
    final url = Uri.https(_apiURL, '/api/checktld', {'email': email});
    final body = (await client.get(url)).body;
    return jsonDecode(body) as String == 'true';
  }

  Future<String> checkEmail(String email) async {
    final url = Uri.https(_apiURL, '/api/v2/Users/check', {'email': email});
    return (await client.get(url)).body;
  }

  Future<String> registerUser(Map<String, dynamic> body) async {
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
      _apiURL,
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
    final url = Uri.https(_apiURL, '/api/v2/CollectGroups/applist');
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
    final url = Uri.https(_apiURL, '/api/v2/users/$guid/givts');
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
        throw GivtServerFailure(
          statusCode: response.statusCode,
          body: jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
      return response.statusCode >= 200;
    });
  }

  Future<bool> putBeaconBatteryStatus({
    required String beaconId,
    required Map<String, dynamic> query,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.https(
      _apiURL,
      '/v2/beacons/$beaconId',
      query,
    );
    return client
        .put(
      url,
      body: jsonEncode(body),
    )
        .then((response) {
      if (response.statusCode >= 400) {
        throw Exception('something went wrong :(');
      }
      return response.statusCode == 200;
    });
  }

  Future<String> signSepaMandate(
    String guid,
    String appLanguage,
  ) async {
    final url = Uri.https(apiURL, '/api/v2/users/$guid/mandate');
    final response = await client.post(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    return response.body;
  }

  Future<bool> unregisterUser(
    Map<String, dynamic> params,
  ) async {
    final url = Uri.https(apiURL, '/api/v2/users/unregister', params);
    final response = await client.post(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    return response.statusCode == 200;
  }

  Future<bool> changeGiftAid(String guid, Map<String, dynamic> body) async {
    final url = Uri.https(apiURL, '/api/v2/users/$guid/giftaidauthorisations');
    final response = await client.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw Exception(response.statusCode);
    }
    return response.statusCode == 200;
  }

  Future<bool> resetPassword(Map<String, dynamic> params) async {
    final url = Uri.https(apiURL, '/api/v2/users/forgotpassword', params);
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw Exception(response.statusCode);
    }
    return response.statusCode == 200;
  }

  Future<bool> contactSupport(Map<String, String> map) async {
    final url = Uri.https(apiURL, '/api/sendsupport');
    final response = await client.post(
      url,
      body: jsonEncode(map),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw Exception(response.statusCode);
    }
    return response.statusCode == 200;
  }
}
