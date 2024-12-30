import 'package:givt_app/features/family/features/missions/presentation/models/mission_ui_model.dart';

class MissionsUIModel {
  MissionsUIModel({
    this.todoMissions = const [],
    this.completedMissions = const [],
  });

  final List<MissionUIModel> todoMissions;
  final List<MissionUIModel> completedMissions;
}
