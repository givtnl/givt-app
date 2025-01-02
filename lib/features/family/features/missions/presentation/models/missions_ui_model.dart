import 'package:givt_app/features/family/shared/design/components/content/models/fun_goal_card_ui_model.dart';

class MissionsUIModel {
  MissionsUIModel({
    this.todoMissions = const [],
    this.completedMissions = const [],
  });

  final List<FunGoalCardUIModel> todoMissions;
  final List<FunGoalCardUIModel> completedMissions;
}
