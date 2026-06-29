import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';

/// Splits external donations into Current vs Past tabs (ENG-652).
///
/// - **Current:** ongoing recurring donations (`active` and not one-off).
/// - **Past:** one-offs and stopped recurring donations.
class ExternalDonationsPartition {
  const ExternalDonationsPartition._();

  static bool isCurrent(ExternalDonation donation) {
    return donation.active &&
        donation.frequency != ExternalDonationFrequency.once;
  }

  static bool isPast(ExternalDonation donation) {
    return donation.frequency == ExternalDonationFrequency.once ||
        !donation.active;
  }

  static List<ExternalDonation> current(List<ExternalDonation> donations) {
    return donations.where(isCurrent).toList()
      ..sort(_compareByDateDesc);
  }

  static List<ExternalDonation> past(List<ExternalDonation> donations) {
    return donations.where(isPast).toList()..sort(_compareByDateDesc);
  }

  static int _compareByDateDesc(
    ExternalDonation first,
    ExternalDonation second,
  ) {
    final firstDate = first.listSortDate;
    final secondDate = second.listSortDate;
    if (firstDate == null || secondDate == null) {
      return second.creationDate.compareTo(first.creationDate);
    }
    return secondDate.compareTo(firstDate);
  }
}
