import 'package:givt_app/core/network/api_service.dart';

mixin CancelRecurringDonationRepository {
  Future<void> cancelRecurringDonation({
    required String recurringDonationId,
  });
}

class CancelRecurringDonationRepositoryImpl
    with CancelRecurringDonationRepository {
  CancelRecurringDonationRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<void> cancelRecurringDonation({
    required String recurringDonationId,
  }) async {
    await apiService.cancelRecurringDonation(
      recurringDonationId: recurringDonationId,
    );
  }
}
