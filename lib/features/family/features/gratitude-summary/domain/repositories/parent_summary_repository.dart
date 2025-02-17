import 'package:givt_app/features/family/features/gratitude-summary/domain/models/parent_summary_item.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

class ParentSummaryRepository {
  ParentSummaryRepository(this._familyAPIService);
  final FamilyAPIService _familyAPIService;
  ParentSummaryItem? latestSummary;

  Future<ParentSummaryItem> fetchLatestGameSummary() async {
    final response = await _familyAPIService.fetchLatestGameSummary();
    return latestSummary = ParentSummaryItem.fromMap(response);
  }

  Future<ParentSummaryItem> getLazyLatestSummary() async {
    if (latestSummary != null) return latestSummary!;
    return fetchLatestGameSummary();
  }
}
