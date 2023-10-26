import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/family_history/models/allowance.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/features/children/family_history/models/history_item.dart';

mixin FamilyDonationHistoryRepository {
  Future<List<HistoryItem>> fetchHistory(
      {required int pageNumber, required HistoryTypes type});
}

class FamilyDonationHistoryRepositoryImpl with FamilyDonationHistoryRepository {
  FamilyDonationHistoryRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<List<HistoryItem>> fetchHistory({
    required int pageNumber,
    required HistoryTypes type,
  }) async {
    final body = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': DonationState.pageSize,
      'type': [type.value]
    };
    final response = await _apiService.fetchHistory(body);

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
