import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/family_history/models/allowance.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/family_history/models/history_item.dart';

mixin FamilyHistoryRepository {
  Future<List<HistoryItem>> fetchHistory(
      {required String childId,
      required int pageNumber,
      required HistoryTypes type});
}

class FamilyHistoryRepositoryImpl with FamilyHistoryRepository {
  FamilyHistoryRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<List<HistoryItem>> fetchHistory(
      {required String childId,
      required int pageNumber,
      required HistoryTypes type}) async {
    final Map<String, dynamic> body = {
      'pageNumber': pageNumber,
      'pageSize': 10,
      'type': type.value
    };
    final response = await _apiService.fetchHistory(childId, body);

    List<HistoryItem> result = [];

    for (final donationMap in response) {
      if (type == HistoryTypes.donation) {
        result.add(ChildDonation.fromMap(donationMap as Map<String, dynamic>));
      }
      if (type == HistoryTypes.allowance) {
        result.add(Allowance.fromMap(donationMap as Map<String, dynamic>));
      }
    }
    return result;
  }
}
