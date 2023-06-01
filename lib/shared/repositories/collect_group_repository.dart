import 'package:givt_app/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectGroupRepository {
  CollectGroupRepository(this._apiClient, this._prefs);

  final APIService _apiClient;
  final SharedPreferences _prefs;

  // todo(alexbejann): implemente this for collectgroup app list to check whether the qr code is active or not
}
