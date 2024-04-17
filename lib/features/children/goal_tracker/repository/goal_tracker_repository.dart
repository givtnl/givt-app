import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/goal_tracker/model/goal.dart';

mixin GoalTrackerRepository {
  Future<Goal> fetchFamilyGoal();
}

class GoalTrackerRepositoryImpl with GoalTrackerRepository {
  GoalTrackerRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<Goal> fetchFamilyGoal() async {
    final response = await _apiService.fetchFamilyGoal();

    if (response.isEmpty) {
      return const Goal.empty();
    }

    return Goal.fromMap(response);
  }
}
