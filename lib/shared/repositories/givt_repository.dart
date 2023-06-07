import 'package:givt_app/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GivtRepository {
  GivtRepository(this._apiClient, this._prefs);

  final APIService _apiClient;
  final SharedPreferences _prefs;

  Future<void> submitGivts({
    required String guid,
    required Map<String, dynamic> body,
  }) async {
    await _apiClient.submitGivts(
      body: {
        'donationType': 0,
      }..addAll(body),
      guid: guid,
    );
  }
}
