import 'dart:convert';
import 'dart:developer';

import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:http/http.dart';

class FamilyAPIService {
  FamilyAPIService(this._requestHelper);

  final RequestHelper _requestHelper;

  Client get client => _requestHelper.client;

  String get _apiURL => _requestHelper.apiURL;

  Future<List<dynamic>> fetchAllProfiles() async {
    final url = Uri.https(_apiURL, '/givtservice/v1/profiles');
    final response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
      final item = decodedBody['item'] as Map<String, dynamic>?;
      return item?['profiles'] as List<dynamic>;
    }
  }

  Future<Map<String, dynamic>> fetchAdminFee() async {
    final url = Uri.https(_apiURL, '/givtservice/v1/config/adminfee');
    final response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
      return decodedBody['item'] as Map<String, dynamic>;
    }
  }

  Future<Map<String, dynamic>> fetchChildDetails(String childGuid) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/profiles/$childGuid');

    final response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
      return decodedBody['item'] as Map<String, dynamic>;
    }
  }

  Future<Map<String, dynamic>> fetchOrganisationDetails(String mediumId) async {
    final url = Uri.https(
      _apiURL,
      'givtservice/v1/organisation/organisation-detail/$mediumId',
    );

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
      return decodedBody['item'] as Map<String, dynamic>;
    }
  }

  Future<void> createTransaction({required Transaction transaction}) async {
    final url = Uri.https(
      _apiURL,
      '/givtservice/v1/transaction',
    );

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transaction.toJson()),
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      final decodedBody = jsonDecode(response.body);
      log(decodedBody.toString());
    }
  }

  Future<List<dynamic>> fetchHistory(
    String childId,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.https(
      _apiURL,
      '/givtservice/v1/profiles/$childId/transactions',
    );

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
    return decodedBody['items'] as List<dynamic>;
  }

  Future<List<dynamic>> fetchTags() async {
    final url = Uri.https(_apiURL, '/givtservice/v1/organisation/tags');

    final response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    final decodedBody = json.decode(response.body) as Map<String, dynamic>;
    return decodedBody['items'] as List<dynamic>;
  }

  Future<List<dynamic>> getRecommendedOrganisations(
    Map<String, dynamic> body,
  ) async {
    final url =
        Uri.https(_apiURL, '/givtservice/v1/organisation/recommendations');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    final decodedBody = json.decode(response.body) as Map<String, dynamic>;
    return decodedBody['items'] as List<dynamic>;
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

  Future<void> editProfile(
    String childGUID,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/profiles/$childGUID');

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

  Future<List<dynamic>> fetchImpactGroups(String childGuid) async {
    final url =
        Uri.https(_apiURL, '/givtservice/v1/profiles/$childGuid/groups');
    final response = await client.get(url);
    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    final itemMap = decodedBody['items']! as List<dynamic>;
    return itemMap;
  }
}
