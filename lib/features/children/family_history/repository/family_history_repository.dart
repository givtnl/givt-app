import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/family_history/models/allowance.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/features/children/family_history/models/history_item.dart';
import 'package:givt_app/features/children/family_history/models/topup.dart';

mixin FamilyDonationHistoryRepository {
  Future<List<HistoryItem>> getHistory({
    required int pageNumber,
  });
}

class FamilyDonationHistoryRepositoryImpl with FamilyDonationHistoryRepository {
  FamilyDonationHistoryRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<List<HistoryItem>> getHistory({
    required int pageNumber,
  }) async {
    final body = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': DonationState.pageSize,
      'type': [
        HistoryTypes.donation.value,
        HistoryTypes.allowance.value,
        HistoryTypes.topUp.value,
      ],
    };

    final response = await _apiService.fetchHistory(body);

    final result = <HistoryItem>[];
    for (final historyItemMap in response) {
      // ignore: avoid_dynamic_calls
      final type = historyItemMap['donationType'];

      if (type == HistoryTypes.donation.value) {
        result
            .add(ChildDonation.fromMap(historyItemMap as Map<String, dynamic>));
      } else if (type == HistoryTypes.allowance.value) {
        result.add(Allowance.fromMap(historyItemMap as Map<String, dynamic>));
      } else if (type == HistoryTypes.topUp.value) {
        result.add(Topup.fromMap(historyItemMap as Map<String, dynamic>));
      }
    }
    return result;
  }
}
