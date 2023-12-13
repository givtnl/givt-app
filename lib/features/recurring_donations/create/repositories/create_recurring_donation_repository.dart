import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/recurring_donations/create/models/recurring_donation.dart';

mixin CreateRecurringDonationRepository {
  Future<bool> createRecurringDonation(RecurringDonation recurringDonation);
}

class CreateRecurringDonationRepositoryImpl
    with CreateRecurringDonationRepository {
  CreateRecurringDonationRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<bool> createRecurringDonation(
    RecurringDonation recurringDonation,
  ) async {
    final response =
        await apiService.createRecurringDonation(recurringDonation.toJson());

    return response;
  }
}
