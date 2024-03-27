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

    if (response.isEmpty) {
      return const FamilyGoal.empty();
    }

    return FamilyGoal.fromMap(response);
  }
}
