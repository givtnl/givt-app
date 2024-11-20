import 'package:givt_app/features/family/features/gratitude-summary/domain/models/summary_item.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

class SummaryRepository {
  SummaryRepository(this._familyAPIService);
  final FamilyAPIService _familyAPIService;

  Future<bool> sendYesNoPutKidToBed({
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

  Future<SummaryItem> fetchLatestGameSummary() async {
    final response = await _familyAPIService.fetchLatestGameSummary();
    return SummaryItem.fromMap(response);
  }
}
