import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/family_goal_tracker/model/family_goal.dart';

mixin GoalTrackerRepository {
  Future<FamilyGoal> fetchFamilyGoal();
}

class GoalTrackerRepositoryImpl with GoalTrackerRepository {
  GoalTrackerRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<FamilyGoal> fetchFamilyGoal() async {
    final response = await _apiService.fetchFamilyGoal();
    FamilyGoal goal;
    if (response.isEmpty) {
      goal = const FamilyGoal.empty();
    } else {
      goal = FamilyGoal.fromMap(response);
    }
    return goal;
  }
}
