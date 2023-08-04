import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation_detail.dart';

mixin RecurringDonationsRepository {
  Future<List<RecurringDonation>> fetchRecurringDonations(String guid);
  Future<List<RecurringDonationDetail>> fetchRecurringInstances(
      String donationId);
}

class RecurringDonationsRepositoryImpl with RecurringDonationsRepository {
  RecurringDonationsRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<List<RecurringDonation>> fetchRecurringDonations(String guid) async {
    final response =
        await apiService.fetchRecurringDonations(params: {'userId': guid});

    final result = <RecurringDonation>[];
    for (final item in response) {
      result.add(RecurringDonation.fromJson(item as Map<String, dynamic>));
    }
    return result;
  }

  @override
  Future<List<RecurringDonationDetail>> fetchRecurringInstances(
      String donationId) async {
    final decodedJson = await apiService.fetchRecurringInstances(donationId);
    // for (final item in decodedJson['results'] as List<Map<String, dynamic>>) {
    //   result.add(RecurringDonationDetail.fromJson(item));
    // }
    var temp = int.parse(decodedJson['count'].toString());
    var responeResults = decodedJson['results'] as List;
    print(responeResults[0]['donationId']);
    if (temp > 1) {
      return RecurringDonationDetail.fromJsonList(
        responeResults,
      );
    }
    return <RecurringDonationDetail>[];
  }
}
