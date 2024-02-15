import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/family_goal_tracker/model/family_goal.dart';

mixin GoalTrackerRepository {
  Future<List<FamilyGoal>> fetchFamilyGoal();
}

class GoalTrackerRepositoryImpl with GoalTrackerRepository {
  GoalTrackerRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<List<FamilyGoal>> fetchFamilyGoal() async {
    final response = await _apiService.fetchFamilyGoal();

    final List<FamilyGoal> goals = [];

    for (final item in response) {
      goals.add(FamilyGoal.fromMap(item as Map<String, dynamic>));
    }
    return goals;
  }
}
