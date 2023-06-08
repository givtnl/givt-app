import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectGroupRepository {
  CollectGroupRepository(this._apiClient, this._prefs);

  final APIService _apiClient;
  final SharedPreferences _prefs;

  Future<List<CollectGroup>> getCollectGroupList() async {
    final response = await _apiClient.getCollectGroupList();
    final organisations = response['OrgBeacons'] as List<dynamic>;
    return organisations
        .map((e) => CollectGroup.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
