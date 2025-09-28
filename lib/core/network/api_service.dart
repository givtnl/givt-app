import 'dart:convert';
import 'dart:io';

import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:http_interceptor/http_interceptor.dart';

class APIService {
  APIService(
    this._requestHelper,
  );

  final RequestHelper _requestHelper;

  Client get client => _requestHelper.client;

  String get _apiURL => _requestHelper.apiURL;

  String get _apiURLAWS => _requestHelper.apiURLAWS;

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
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  Future<Map<String, dynamic>> getUserExtension(String guid) async {
    final url = Uri.https(_apiURL, '/api/v2/UsersExtension/$guid');
    final response = await client.get(url);
    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<bool> checktld(String email) async {
    final url = Uri.https(_apiURL, '/api/checktld', {'email': email});
    final response = await client.get(url);
    final body = response.body;
    return jsonDecode(body) as String == 'true';
  }

  Future<String> checkEmail(String email) async {
    final url = Uri.https(_apiURL, '/api/v2/Users/check', {'email': email});
    return (await client.get(url)).body;
  }

  Future<String> registerUser(Map<String, dynamic> body) async {
    final url = Uri.https(_apiURL, '/api/v2/users');

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

  Future<Map<String, dynamic>> registerGenerosityChallengeUser(
    Map<String, dynamic> body,
  ) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/generositychallenge/user');

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(body),
    );
    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
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
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getCollectGroupList() {
    final url = Uri.https(_apiURL, '/api/v2/CollectGroups/applist-v2');
    return client.get(url).then((response) {
      if (response.statusCode >= 400) {
        throw GivtServerFailure(
          statusCode: response.statusCode,
          body: jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    });
  }

  Future<List<int>> submitGivts({
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
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final ids = body['TransactionIds'] as List<dynamic>;
        return ids.map((e) => e as int).toList();
      }

      return [];
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
        throw GivtServerFailure(
          statusCode: response.statusCode,
          body: jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
      return response.statusCode == 200;
    });
  }

  Future<String> signSepaMandate(
    String guid,
    String appLanguage,
  ) async {
    final url = Uri.https(_apiURL, '/api/v2/users/$guid/mandate');
    final response = await client.post(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    return response.body;
  }

  Future<Map<String, dynamic>> fetchStripeSetupIntent() async {
    final url = Uri.https(
      _apiURL,
      '/givtservice/v1/paymentprovider/mandate/stripe',
    );

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      return responseBody['item'] as Map<String, dynamic>;
    } else {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
  }

  Future<bool> unregisterUser(
    Map<String, dynamic> params,
  ) async {
    final url = Uri.https(_apiURL, '/api/users/unregister', params);
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
    final url = Uri.https(_apiURL, '/api/v2/users/$guid/giftaidauthorisations');
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
    final url = Uri.https(_apiURL, '/api/v2/users/forgotpassword', params);
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

  Future<bool> contactSupport(Map<String, String> body) async {
    final url = Uri.https(_apiURL, '/api/sendsupport');
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

  Future<Map<String, dynamic>> checkAppUpdate(Map<String, String> body) async {
    final url = Uri.https(_apiURL, '/api/checkforupdate');
    final response = await client.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    if (response.body.isEmpty) {
      return {};
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<dynamic>> fetchGivts() async {
    final url = Uri.https(_apiURL, '/givtservice/v1/transaction/family');

    final response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    return jsonDecode(response.body)['items'] as List<dynamic>;
  }

  Future<bool> deleteGivts({List<dynamic>? body}) async {
    final url = Uri.https(_apiURL, '/api/v2/Givts/multiple');

    final response = await client.delete(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    return response.statusCode == 200;
  }

  Future<bool> updateUserExt(Map<String, dynamic> body) async {
    final url = Uri.https(_apiURL, '/api/v2/usersExtension');

    final response = await client.put(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
    return response.statusCode == 200;
  }

  Future<bool> updateUser(String guid, Map<String, dynamic> body) async {
    final url = Uri.https(_apiURL, '/api/v2/Users/$guid');

    final response = await client.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    return response.statusCode == 200;
  }

  Future<bool> downloadYearlyOverview(Map<String, dynamic> body) async {
    final url = Uri.https(_apiURLAWS, '/donations/download');
    final response = await client.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'x-json-casing': 'PascalKeeze',
      },
    );
    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    return response.statusCode == 202;
  }

  Future<bool> addMember(Map<String, dynamic> body) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/profiles');

    final response = await client.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    final isError = decodedBody['isError'] as bool;

    if (response.statusCode == 200 && isError) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: decodedBody,
      );
    }
    return response.statusCode == 200;
  }

  Future<bool> editChild(String childGUID, Map<String, dynamic> body) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/ChildProfile/$childGUID');

    final response = await client.put(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    return response.statusCode == 200;
  }

  Future<bool> editChildAllowance(String childGUID, int allowance) async {
    final url =
        Uri.https(_apiURL, '/givtservice/v1/profiles/$childGUID/allowance');

    final response = await client.put(
      url,
      body: jsonEncode({'amount': allowance}),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> submitParentalApprovalDecision({
    required String childId,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.https(
      _apiURL,
      'givtservice/v1/Transaction/$childId/donation-approval',
    );

    final response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isEmpty
            ? {}
            : jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<dynamic>> fetchRecurringDonations({
    required Map<String, dynamic> params,
  }) async {
    final url = Uri.https(_apiURLAWS, '/recurringdonations');

    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    return decodedBody['results'] as List<dynamic>;
  }

  Future<void> cancelRecurringDonation({
    required String recurringDonationId,
  }) async {
    final url = Uri.https(
      _apiURLAWS,
      'recurringdonations/${recurringDonationId.toLowerCase()}/cancel',
    );

    final response =
        await client.patch(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
  }

  Future<Map<String, dynamic>> fetchRecurringInstances(
    String donationId,
  ) async {
    final url =
        Uri.https(_apiURLAWS, 'recurringdonations/$donationId/donations');

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-json-casing': 'PascalKeeze',
      },
    );
    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<bool> createRecurringDonation(Map<String, dynamic> body) async {
    final url = Uri.https(_apiURLAWS, '/recurringdonations');

    final response = await client.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    return response.statusCode == 201;
  }

  Future<List<dynamic>> fetchExternalDonations({
    required Map<String, dynamic> params,
  }) async {
    final url = Uri.https(_apiURLAWS, '/external-donations', params);

    final response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    return decodedBody['result'] as List<dynamic>;
  }

  Future<List<dynamic>> fetchExternalDonationsSummary({
    required Map<String, dynamic> params,
  }) async {
    final url = Uri.https(_apiURLAWS, '/external-donations/summary', params);

    final response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<bool> deleteExternalDonation(String id) async {
    final url = Uri.https(_apiURLAWS, '/external-donations/$id');

    final response = await client.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<bool> addExternalDonation(Map<String, dynamic> body) async {
    final url = Uri.https(_apiURLAWS, '/external-donations');

    final response = await client.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
    return response.statusCode == 201;
  }

  Future<bool> updateExternalDonation(
    String id,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.https(_apiURLAWS, '/external-donations/$id');

    final response = await client.patch(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }

    return response.statusCode == 204;
  }

  Future<bool> updateNotificationId({
    required String guid,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/profiles/pushnotification');

    final response = await client.patch(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }

    return response.statusCode == 200;
  }

  Future<List<dynamic>> fetchMonthlySummary(
    String guid,
    Map<String, String> params,
  ) async {
    final url = Uri.https(_apiURL, '/api/v2/users/$guid/summary', params);

    final response = await client.get(url);
    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<Map<String, dynamic>> fetchGivingGoal() async {
    final url = Uri.https(_apiURLAWS, '/giving-goal');

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<bool> addGivingGoal({
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.https(
      _apiURLAWS,
      '/giving-goal',
    );

    final response = await client.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }

    return response.statusCode == 201;
  }

  Future<bool> removeGivingGoal() {
    final url = Uri.https(_apiURLAWS, '/giving-goal');

    return client.delete(
      url,
      body: '',
      headers: {
        'Content-Type': 'application/json',
      },
    ).then((response) {
      if (response.statusCode >= 400) {
        throw GivtServerFailure(
          statusCode: response.statusCode,
          body: response.body.isNotEmpty
              ? jsonDecode(response.body) as Map<String, dynamic>
              : null,
        );
      }
      return response.statusCode == 200;
    });
  }

  Future<List<dynamic>> fetchHistory(Map<String, dynamic> body) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/profiles/transactions');

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    final itemMap = decodedBody['items'];
    return itemMap as List<dynamic>;
  }

  Future<List<dynamic>> fetchAvatars() async {
    final url = Uri.https(_apiURL, '/givtservice/v1/profiles/avatars');

    final response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    final itemMap = decodedBody['items'];
    return itemMap as List<dynamic>;
  }

  Future<void> editProfile(Map<String, dynamic> body) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/profiles');

    final response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
  }

  Future<bool> topUpChild(String childGUID, int amount) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/profiles/$childGUID/topup');

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    final isError = decodedBody['isError'] as bool;

    if (response.statusCode == 200 && isError) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: decodedBody,
      );
    }
    return response.statusCode == 200;
  }

  Future<bool> cancelAllowance(
    String childGUID,
  ) async {
    final url =
        Uri.https(_apiURL, '/givtservice/v1/profiles/$childGUID/allowance');

    final response = await client.delete(
      url,
      body: '',
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }

    return response.statusCode == 200;
  }

  Future<bool> acceptGroupInvite(
    String groupId,
  ) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/groups/$groupId/accept');

    final response = await client.post(
      url,
      body: '',
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }

    return response.statusCode == 200;
  }

  Future<bool> declineGroupInvite(
    String groupId,
  ) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/groups/$groupId/decline');

    final response = await client.post(
      url,
      body: '',
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }

    return response.statusCode == 200;
  }

  Future<List<dynamic>> fetchImpactGroups() async {
    final url = Uri.https(_apiURL, '/givtservice/v1/groups');
    final response = await client.get(url);

    if (response.statusCode >= 400 && response.statusCode < 500) {
      return [];
    }

    if (response.statusCode >= 500) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    final itemMap = decodedBody['items']! as List<dynamic>;

    return itemMap;
  }

  Future<bool> setBoxOrigin({
    required String orgId,
    required String groupId,
  }) async {
    final url =
        Uri.https(_apiURL, '/givtservice/v1/groups/$groupId/box-origin');

    final response = await client.put(
      url,
      body: jsonEncode({'CollectGroupNamespace': orgId}),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }

    return response.statusCode == 200;
  }

  Future<void> createFamilyGoal(Map<String, dynamic> body) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/goal/family');

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
  }

  Future<bool> editChildBedtime(
    String childGUID,
    String bedtime,
    int winddownMinutes,
  ) async {
    final url =
        Uri.https(_apiURL, '/givtservice/v1/profiles/$childGUID/bedtime');
    final response = await client.put(
      url,
      body: jsonEncode({
        'bedtime': bedtime,
        'winddowntime': winddownMinutes,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }

    return response.statusCode == 200;
  }
}
