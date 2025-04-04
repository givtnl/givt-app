import 'package:givt_app/features/family/features/missions/domain/entities/mission.dart';

mixin MissionRepository {
  Future<List<Mission>> getMissions({bool force = false});
  Future<void> missionAchieved(String missionKey);

  Stream<Mission> onMissionAchieved();
  Stream<List<Mission>> onMissionsUpdated();
}
