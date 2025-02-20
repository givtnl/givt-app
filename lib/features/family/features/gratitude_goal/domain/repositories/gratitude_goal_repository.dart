import 'package:givt_app/features/family/features/gratitude_goal/domain/models/behavior_options.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/models/set_a_goal_options.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

class GratitudeGoalRepository {
  const GratitudeGoalRepository(this._familyAPIService);

  final FamilyAPIService _familyAPIService;

  Future<bool> submit(
      SetAGoalOptions chosenOption, BehaviorOptions behavior) async {
    final result =
        await _familyAPIService.saveGratitudeGoal(chosenOption, behavior);
    return result;
  }
}
