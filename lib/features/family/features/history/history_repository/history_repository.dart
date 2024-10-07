import 'package:givt_app/features/family/features/history/models/donation.dart';
import 'package:givt_app/features/family/features/history/models/history_item.dart';
import 'package:givt_app/features/family/features/history/models/income.dart';
import 'package:givt_app/features/family/network/api_service.dart';

mixin HistoryRepository {
  Future<List<HistoryItem>> fetchHistory({
    required String childId,
    required int pageNumber,
    required HistoryTypes type,
  });
}

class HistoryRepositoryImpl with HistoryRepository {
  HistoryRepositoryImpl(
    this._apiService,
  );

  final FamilyAPIService _apiService;

  @override
  Future<List<HistoryItem>> fetchHistory({
    required String childId,
    required int pageNumber,
    required HistoryTypes type,
  }) async {
    final body = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': 10,
      'type': type.value,
    };

    final response = await _apiService.fetchHistory(childId, body);

    final result = <HistoryItem>[];

    for (final donationMap in response) {
      if ((donationMap['status'] == 'Rejected' ||
              donationMap['status'] == 'Cancelled') &&
          donationMap['donationType'] != HistoryTypes.donation.value) {
        continue;
      }

      if (donationMap['donationType'] == HistoryTypes.donation.value) {
        result.add(
          Donation.fromMap(donationMap as Map<String, dynamic>) as HistoryItem,
        );
      }
      if (donationMap['donationType'] == HistoryTypes.allowance.value ||
          donationMap['donationType'] == HistoryTypes.topUp.value) {
        result.add(
          Income.fromMap(donationMap as Map<String, dynamic>) as HistoryItem,
        );
      }
    }
    return result;
  }
}
