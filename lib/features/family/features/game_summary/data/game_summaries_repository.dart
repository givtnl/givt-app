import 'package:givt_app/features/family/features/game_summary/data/models/game_summary_item.dart';
import 'package:givt_app/features/family/features/gratitude-summary/domain/models/parent_summary_item.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

class GameSummariesRepository {
  GameSummariesRepository(this._familyAPIService);
  final FamilyAPIService _familyAPIService;

  Future<List<GameSummaryItem>> fetchGameSummaries(
      List<Profile> profiles) async {
    final response = await _familyAPIService.fetchGameSummaries();
    return response
        .map(
            (e) => GameSummaryItem.fromMap(e as Map<String, dynamic>, profiles))
        .toList();
  }

  Future<ParentSummaryItem> fetchGameSummary(String id) async {
    final response = await _familyAPIService.fetchGameSummary(id);
    return ParentSummaryItem.fromMap(response);
  }
}
