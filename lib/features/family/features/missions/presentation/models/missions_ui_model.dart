import 'package:givt_app/shared/design_system/design_system.dart';

class MissionsUIModel {
  MissionsUIModel({
    this.todoMissions = const [],
    this.completedMissions = const [],
  });

  final List<FunMissionCardUIModel> todoMissions;
  final List<FunMissionCardUIModel> completedMissions;
}
