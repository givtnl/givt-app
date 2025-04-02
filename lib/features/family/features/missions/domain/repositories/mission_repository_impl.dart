import 'dart:async';

import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/missions/domain/entities/mission.dart';
import 'package:givt_app/features/family/features/missions/domain/repositories/mission_repository.dart';
import 'package:givt_app/features/family/features/tutorial/domain/tutorial_repository.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

class MissionRepositoryImpl implements MissionRepository {
  MissionRepositoryImpl(
      this._apiService, this._authRepository, this._tutorialRepository) {
    _init();
  }

  final FamilyAPIService _apiService;
  final FamilyAuthRepository _authRepository;
  final TutorialRepository _tutorialRepository;

  final StreamController<Mission> _missionAchievedStreamController =
      StreamController<Mission>.broadcast();

  final StreamController<List<Mission>> _missionsStreamController =
      StreamController<List<Mission>>.broadcast();

  List<Mission> _missions = [];

  void _init() {
    _authRepository.authenticatedUserStream().listen(
      (user) {
        if (user != null) {
          _clearData();
          if (!user.tempUser && user.personalInfoRegistered) {
            refreshMissions();
          }
        } else {
          _clearData();
        }
      },
    );
  }

  void _clearData() {
    _missions = [];
    _missionsStreamController.add(_missions);
  }

  Future<void> refreshMissions() async {
    try {
      await _fetchMissions();
    } catch (e) {
      // do nothing
    }
  }

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
    var mission =
        (await getMissions()).firstWhere((m) => m.missionKey == missionKey);
    if (_tutorialRepository.gratitudeMissionStartedFromTutorial &&
        mission.missionKey == 'GRATITUDEGOAL') {
      mission = mission.copyWith(showAchievedTooltip: true);
    }
    _missionAchievedStreamController.add(mission);
    await _fetchMissions();
  }

  @override
  Stream<Mission> onMissionAchieved() =>
      _missionAchievedStreamController.stream;

  @override
  Stream<List<Mission>> onMissionsUpdated() => _missionsStreamController.stream;
}
