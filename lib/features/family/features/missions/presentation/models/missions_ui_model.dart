import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';

class MissionsUIModel {
  MissionsUIModel({
    this.todoMissions = const [],
    this.completedMissions = const [],
  });

  final List<FunMissionCardUiModel> todoMissions;
  final List<FunMissionCardUiModel> completedMissions;
}
