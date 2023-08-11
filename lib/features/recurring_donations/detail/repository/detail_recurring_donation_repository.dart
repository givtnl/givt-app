import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/overview/models/givt.dart';
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
    String donationId,
  ) async {
    final decodedJsonInstances =
        await apiService.fetchRecurringInstances(donationId);
    final responeResults = decodedJsonInstances['results'] as List;

    final instanceIds = <String>[];
    for (final element in responeResults) {
      instanceIds.add(element['donationId'].toString());
    }

    final decodedJsonGivts = await apiService.fetchGivts();
    final instancesAsGivts = Givt.fromJsonList(decodedJsonGivts);

    final selectedGivts = instancesAsGivts.where((element) {
      return instanceIds.contains(element.id.toString());
    }).toList();

    return RecurringDonationDetail.fromGivtsList(
      selectedGivts,
    );
  }
}
