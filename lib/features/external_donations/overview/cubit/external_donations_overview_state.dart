part of 'external_donations_overview_cubit.dart';

class ExternalDonationsOverviewUIModel {
  const ExternalDonationsOverviewUIModel({
    required this.currentDonations,
    required this.pastDonations,
  });

  final List<ExternalDonation> currentDonations;
  final List<ExternalDonation> pastDonations;

  bool get hasCurrentDonations => currentDonations.isNotEmpty;
  bool get hasPastDonations => pastDonations.isNotEmpty;
  bool get isEmpty => !hasCurrentDonations && !hasPastDonations;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExternalDonationsOverviewUIModel &&
        other.currentDonations == currentDonations &&
        other.pastDonations == pastDonations;
  }

  @override
  int get hashCode =>
      Object.hash(currentDonations, pastDonations);
}

sealed class ExternalDonationsOverviewCustom {
  const ExternalDonationsOverviewCustom();
}
