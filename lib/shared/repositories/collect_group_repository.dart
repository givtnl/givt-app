import 'dart:convert';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectGroupRepository {
  CollectGroupRepository(this._apiClient, this._prefs);

  final APIService _apiClient;
  final SharedPreferences _prefs;

  Future<List<CollectGroup>> fetchCollectGroupList() async {
    final response = await _apiClient.getCollectGroupList();
    final orgBeaconList = response['OrgBeacons'] as List<dynamic>;
    final collectGroups = orgBeaconList
        .map((e) => CollectGroup.fromJson(e as Map<String, dynamic>))
        .toList();
    await _saveCollectGroupList(collectGroups);
    return collectGroups;
  }

  Future<List<CollectGroup>> getCollectGroupList() async {
    final collectGroups = _prefs.getStringList(
      CollectGroup.orgBeaconListKey,
    );
    if (collectGroups == null) {
      return [];
    }
    return collectGroups
        .map(
          (e) => CollectGroup.fromJson(jsonDecode(e) as Map<String, dynamic>),
        )
        .toList();
  }

  Future<bool> _saveCollectGroupList(List<CollectGroup> collectGroups) async {
    return _prefs.setStringList(
      CollectGroup.orgBeaconListKey,
      collectGroups.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }
}
