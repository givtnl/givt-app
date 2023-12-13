import 'dart:convert';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin CollectGroupRepository {
  Future<List<CollectGroup>> fetchCollectGroupList();
  Future<List<CollectGroup>> getCollectGroupList();
}

class CollectGroupRepositoryImpl with CollectGroupRepository {
  CollectGroupRepositoryImpl(this.apiClient, this.prefs);

  final APIService apiClient;
  final SharedPreferences prefs;

  @override
  Future<List<CollectGroup>> fetchCollectGroupList() async {
    final response = await apiClient.getCollectGroupList();
    final orgBeaconList = response['CGS'] as List<dynamic>;
    final collectGroups = orgBeaconList
        .map((e) => CollectGroup.fromJson(e as Map<String, dynamic>))
        .toList();
    await _saveCollectGroupList(collectGroups);
    return collectGroups;
  }

  @override
  Future<List<CollectGroup>> getCollectGroupList() async {
    final collectGroups = prefs.getStringList(
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
    return prefs.setStringList(
      CollectGroup.orgBeaconListKey,
      collectGroups.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }
}
