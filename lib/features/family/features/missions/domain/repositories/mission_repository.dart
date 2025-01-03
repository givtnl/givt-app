import 'package:givt_app/features/family/features/missions/domain/entities/mission.dart';

abstract class MissionRepository {
  Future<List<Mission>> getMissions();
  Future<void> addMission(Mission mission);
  Future<void> completeMission(String missionKey);
  Future<void> unCompleteMission(String missionKey);
  Future<void> updateMissionProgress(String missionKey, double progress);
}