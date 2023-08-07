import 'dart:developer';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/recurring_donations/detail/models/recurring_donation_detail.dart';

mixin DetailRecurringDonationsRepository {
  Future<List<RecurringDonationDetail>> fetchRecurringInstances(
    String donationId,
  );
}

class DetailRecurringDonationsRepositoryImpl
    with DetailRecurringDonationsRepository {
  DetailRecurringDonationsRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<List<RecurringDonationDetail>> fetchRecurringInstances(
      String donationId) async {
    final decodedJson = await apiService.fetchRecurringInstances(donationId);
    // for (final item in decodedJson['results'] as List<Map<String, dynamic>>) {
    //   result.add(RecurringDonationDetail.fromJson(item));
    // }
    var responeResults = decodedJson['results'] as List;
    log(responeResults[0]['donationId'].toString());

    return RecurringDonationDetail.fromJsonList(
      responeResults,
    );
  }
}
