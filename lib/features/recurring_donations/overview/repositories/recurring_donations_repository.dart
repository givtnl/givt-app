import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';

mixin RecurringDonationsRepository {
  Future<List<RecurringDonation>> fetchRecurringDonations(String guid);
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
}
