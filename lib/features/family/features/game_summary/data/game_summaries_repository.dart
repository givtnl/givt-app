import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/family/features/game_summary/data/models/game_summary_item.dart';
import 'package:givt_app/features/family/features/gratitude-summary/domain/models/parent_summary_item.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

class GameSummariesRepository {
  GameSummariesRepository(this._familyAPIService);
  final FamilyAPIService _familyAPIService;

  Future<List<GameSummaryItem>> fetchGameSummaries(
      List<Profile> profiles) async {
    try {
      final response = await _familyAPIService.fetchGameSummaries();
      return response
          .map((e) =>
              GameSummaryItem.fromMap(e as Map<String, dynamic>, profiles))
          .toList();
    } on Exception catch (e) {
      LoggingInfo.instance.error('Error fetching game summaries: $e');
      throw Exception('Error fetching game summaries: $e');
    }
  }

  Future<ParentSummaryItem> fetchGameSummary(String id) async {
    try {
      final response = await _familyAPIService.fetchGameSummary(id);
      return ParentSummaryItem.fromMap(response);
    } on Exception catch (e) {
      LoggingInfo.instance.error('Error fetching a game summary: $e');
      throw Exception('Error fetching game summary: $e');
    }
  }
}
