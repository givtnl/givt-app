import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/family_goal/models/family_goal.dart';

mixin CreateFamilyGoalRepository {
  Future<void> createFamilyGoal({required FamilyGoal familyGoal});
}

class CreateFamilyGoalRepositoryImpl with CreateFamilyGoalRepository {
  CreateFamilyGoalRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<void> createFamilyGoal({required FamilyGoal familyGoal}) async {
    await _apiService.createFamilyGoal(familyGoal.toJson());
  }
}
