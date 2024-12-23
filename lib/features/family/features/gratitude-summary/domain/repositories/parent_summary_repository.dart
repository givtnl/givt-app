import 'package:givt_app/features/family/features/gratitude-summary/domain/models/parent_summary_item.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

class ParentSummaryRepository {
  ParentSummaryRepository(this._familyAPIService);
  final FamilyAPIService _familyAPIService;
  ParentSummaryItem? latestSummary;

  Future<bool> assignBedtimeResponsibility({
    required String childGuid,
    required String parentGuid,
    required bool yes,
  }) async {
    return _familyAPIService.putKidToBed(
      childGuid: childGuid,
      parentGuid: parentGuid,
      yes: yes,
    );
  }

  Future<ParentSummaryItem> fetchLatestGameSummary() async {
    final response = await _familyAPIService.fetchLatestGameSummary();
    return latestSummary = ParentSummaryItem.fromMap(response);
  }

  Future<ParentSummaryItem> getLazyLatestSummary() async {
    if (latestSummary != null) return latestSummary!;
    return fetchLatestGameSummary();
  }
}
