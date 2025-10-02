import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/family/features/generosity_hunt/models/scan_response.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/models/behavior_options.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/models/set_a_goal_options.dart';
import 'package:http/http.dart';

class FamilyAPIService {
  FamilyAPIService(this._requestHelper);

  final RequestHelper _requestHelper;

  Client get client => _requestHelper.client;

  String get _apiURL => _requestHelper.apiURL;

  Future<List<dynamic>> fetchLeague() async {
    final url = Uri.https(_apiURL, '/givtservice/v1/groups/family/league');
    final response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
      return decodedBody['items'] as List<dynamic>;
    }
  }

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

  Future<List<dynamic>> fetchHistory(
    String userId,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.https(
      _apiURL,
      '/givtservice/v1/profiles/$userId/transactions',
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

  Future<List<dynamic>> getRecommendedAOS(
    Map<String, dynamic> body,
  ) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/game/aos-recommendation');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    debugPrint('Recommended AOS response: $response, body: ${response.body}');

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

  Future<bool> saveGratitudeGoal(
      SetAGoalOptions goal, BehaviorOptions behavior) async {
    final url =
        Uri.https(_apiURL, '/givtservice/v1/groups/family/gratitude-goal');

    final response = await client.post(
      url,
      body: jsonEncode({
        'behavior': behavior.index,
        'goal': goal.timesAWeek,
      }),
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

  Future<bool> setupRecurringAmount(String childGUID, int allowance) async {
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

  Future<Map<String, dynamic>> getQuestionForHero(
    String gameGuid,
    String userGuid, {
    File? audioFile,
    int questionNumber = 0,
  }) async {
    final url = Uri.https(
      _apiURL,
      '/givtservice/v1/game/$gameGuid/$userGuid/question/$questionNumber',
    );

    final request = MultipartRequest('POST', url)
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
      });
    if (audioFile != null) {
      request.files.add(
        MultipartFile(
          'file', // Name of the field expected by the server
          audioFile.readAsBytes().asStream(),
          audioFile.lengthSync(),
          filename: 'audio_recording_message.m4a',
        ),
      );
    }

    final response = await Response.fromStream(await client.send(request));

    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    final itemMap = decodedBody['item']! as Map<String, dynamic>;
    return itemMap;
  }

  Future<bool> uploadEndOfRoundHeroAudioFile(
      String gameGuid, String userGuid, File audioFile) async {
    final url = Uri.https(
        _apiURL, '/givtservice/v1/game/$gameGuid/$userGuid/conversation');

    final request = MultipartRequest('POST', url)
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
      })
      ..files.add(
        MultipartFile(
          'file', // Name of the field expected by the server
          audioFile.readAsBytes().asStream(),
          audioFile.lengthSync(),
          filename: 'audio_recording_message.m4a',
        ),
      );

    final response = await Response.fromStream(await client.send(request));

    if (response.statusCode >= 300) {
      final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty ? decodedBody : null,
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

  Future<bool> uploadAudioFile(String gameGuid, File audioFile) async {
    final url =
        Uri.https(_apiURL, '/givtservice/v1/game/$gameGuid/upload-message');

    final request = MultipartRequest('POST', url)
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
      })
      ..files.add(
        MultipartFile(
          'file', // Name of the field expected by the server
          audioFile.readAsBytes().asStream(),
          audioFile.lengthSync(),
          filename: 'audio_summary_message.m4a',
        ),
      );

    final response = await Response.fromStream(await client.send(request));

    if (response.statusCode >= 300) {
      final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty ? decodedBody : null,
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

  Future<bool> savePledge(
    Map<String, dynamic> body,
  ) async {
    return _postRequest(
      '/givtservice/v1/game/aos',
      body,
    );
  }

  Future<bool> createTransaction({required Transaction transaction}) async {
    return _postRequest(
      '/givtservice/v1/transaction',
      transaction.toJson(),
    );
  }

  Future<bool> topUpChild(String childGUID, int amount) async {
    return _postRequest(
      '/givtservice/v1/profiles/$childGUID/topup',
      {'amount': amount},
    );
  }

  Future<Map<String, dynamic>> saveGratitudeStats(
    int duration,
    String? gameGuid,
  ) async {
    return updateGame(gameGuid!, {
      'type': 'Gratitude',
      'duration': duration,
    });
  }

  Future<bool> resetPassword(String email) async {
    final url =
        Uri.https(_apiURL, '/api/v2/users/forgotpassword', {'email': email});
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

  Future<bool> changePassword({
    required String userID,
    required String passwordToken,
    required String newPassword,
  }) async {
    final url = Uri.https(_apiURL, '/api/Users/ResetPassword');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userID': userID,
        'passwordToken': passwordToken,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception(response.statusCode);
    }
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> updateGame(
      String gameGuid, Map<String, dynamic> body) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/game/$gameGuid');
    final response = await client.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body));
    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    return decodedBody['item']! as Map<String, dynamic>;
  }

  Future<String> createGame(
      {required List<String> guids, String type = 'Gratitude'}) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/Game');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'Players': guids,
        'Type': type,
      }),
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
    final itemMap = decodedBody['item']! as Map<String, dynamic>;
    return itemMap['id'] as String;
  }

  Future<bool> saveUserGratitudeCategory({
    required String gameGuid,
    required String userid,
    required String category,
    required String power,
  }) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/game/$gameGuid/user');
    final response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'userid': userid,
          'category': category,
          'generous': power,
        }));
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

  Future<List<dynamic>> fetchGameSummaries() async {
    final url = Uri.https(_apiURL, '/givtservice/v1/game/summary');
    final response = await client.post(url);
    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    final itemList = decodedBody['items'] as List<dynamic>;
    return itemList;
  }

  Future<Map<String, dynamic>> fetchGameSummary(String id) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/game/summary/$id');
    final response = await client.get(url);
    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    final itemMap = decodedBody['item']! as Map<String, dynamic>;
    return itemMap;
  }

  Future<Map<String, dynamic>> fetchLatestGameSummary() async {
    final url = Uri.https(_apiURL, '/givtservice/v1/game/summary/latest');
    final response = await client.get(url);
    if (response.statusCode >= 300) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    final itemMap = decodedBody['item']! as Map<String, dynamic>;
    return itemMap;
  }

  Future<Map<String, dynamic>> fetchGameStats() async {
    final url = Uri.https(_apiURL, '/givtservice/v1/game/statistics');
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

  Future<List<dynamic>> fetchGenerosityHuntLevels() async {
    final url =
        Uri.https(_apiURL, '/givtservice/v1/game/generosity-hunt/levels');
    final response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    return decodedBody['items'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> fetchGenerosityHuntUserState(String userId) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/game/generosity-hunt/$userId');
    final response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    return decodedBody['item'] as Map<String, dynamic>;
  }

  Future<ScanResponse> scanBarcode({
    required String userId,
    required String barcode,
  }) async {
    final url = Uri.https(_apiURL, '/givtservice/v1/game/generosity-hunt/scan');
    final body = {
      'userid': userId,
      'barcode': barcode,
    };

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 404) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: const {'error': 'Barcode not found'},
      );
    }

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    return ScanResponse.fromJson(decodedBody);
  }

  Future<bool> _postRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.https(_apiURL, endpoint);
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
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

  Future<List<dynamic>> fetchFamilyMissions() async {
    final url = Uri.https(_apiURL, '/givtservice/v1/missions/family');
    final response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerFailure(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    return decodedBody['items'] as List<dynamic>;
  }

  Future<int> fetchTotalFamilyGameCount() async {
    final url = Uri.https(_apiURL, '/givtservice/v1/game/group/family/count');
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
    return decodedBody['item'] as int;
  }
}
