import 'dart:convert';

import 'package:givt_app/features/family/features/missions/domain/entities/mission.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MissionLocalDataSource {
  Future<List<Mission>> getMissions();
  Future<void> saveMissions(List<Mission> missions);
}

class MissionLocalDataSourceImpl implements MissionLocalDataSource {
  static const _missionsKey = 'missions';

  @override
  Future<List<Mission>> getMissions() async {
    final prefs = await SharedPreferences.getInstance();
    final missionJson = prefs.getString(_missionsKey);

    if (missionJson == null) {
      // Default list
      // We might need to check if there is already bedtime set?
      return [
        const Mission(
          missionKey: 'BEDTIME',
          title: 'Mission Bedtime',
          description: 'Make it a habit',
          progress: 0,
          namedPath: 'FamilyPages.setupBedtime.name',
        )
      ];
    }

    final decodedList = jsonDecode(missionJson) as List<dynamic>;
    return decodedList
        .map((json) => Mission.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveMissions(List<Mission> missions) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = missions.map((mission) => mission.toJson()).toList();
    await prefs.setString(_missionsKey, jsonEncode(encodedList));
  }
}
