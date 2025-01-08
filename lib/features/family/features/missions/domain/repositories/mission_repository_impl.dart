import 'dart:async';

import 'package:givt_app/features/family/features/missions/domain/entities/mission.dart';
import 'package:givt_app/features/family/features/missions/domain/repositories/mission_repository.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

class MissionRepositoryImpl implements MissionRepository {
  MissionRepositoryImpl(this._apiService);

  final FamilyAPIService _apiService;

  final StreamController<Mission> _missionAchievedStreamController =
      StreamController<Mission>.broadcast();

  final StreamController<List<Mission>> _missionsStreamController =
      StreamController<List<Mission>>.broadcast();

  List<Mission> _missions = [];

  @override
  Future<List<Mission>> getMissions({bool force = false}) async {
    if (force || _missions.isEmpty) {
      await _fetchMissions();
    }

    return _missions;
  }

  Future<void> _fetchMissions() async {
    _missions = (await _apiService.fetchFamilyMissions())
        .map((m) => Mission.fromJson(m as Map<String, dynamic>))
        .toList();

    _missionsStreamController.add(_missions);
  }

  @override
  Future<void> missionAchieved(String missionKey) async {
    final mission = (await getMissions()).firstWhere((m) => m.missionKey == missionKey);
    _missionAchievedStreamController.add(mission);
    await _fetchMissions();
  }

  @override
  Stream<Mission> onMissionAchieved() =>
      _missionAchievedStreamController.stream;

  @override
  Stream<List<Mission>> onMissionsUpdated() => _missionsStreamController.stream;
}
