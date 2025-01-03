import 'package:givt_app/features/family/features/missions/data/datasources/mission_local_datasource.dart';
import 'package:givt_app/features/family/features/missions/domain/entities/mission.dart';
import 'package:givt_app/features/family/features/missions/domain/repositories/mission_repository.dart';

class MissionRepositoryImpl implements MissionRepository {
  MissionRepositoryImpl({required this.localDataSource});

  final MissionLocalDataSource localDataSource;

  @override
  Future<List<Mission>> getMissions() async {
    return localDataSource.getMissions();
  }

  @override
  Future<void> addMission(Mission mission) async {
    final currentMissions = await localDataSource.getMissions();

    // If you want to prevent duplicates by key, remove existing first:
    currentMissions
      ..removeWhere((m) => m.missionKey == mission.missionKey)
      ..add(mission);
    await localDataSource.saveMissions(currentMissions);
  }

  @override
  Future<void> completeMission(String missionKey) async {
    final currentMissions = await localDataSource.getMissions();

    final updated = currentMissions.map((m) {
      if (m.missionKey == missionKey) {
        return m.copyWith(isCompleted: true, progress: 1);
      }
      return m;
    }).toList();

    await localDataSource.saveMissions(updated);
  }

  @override
  Future<void> updateMissionProgress(String missionKey, double progress) async {
    final currentMissions = await localDataSource.getMissions();
    final updated = currentMissions.map((m) {
      if (m.missionKey == missionKey && !m.isCompleted()) {
        return m.copyWith(progress: progress);
      }
      return m;
    }).toList();

    await localDataSource.saveMissions(updated);
  }
}
