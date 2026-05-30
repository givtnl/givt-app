part of 'external_donations_overview_cubit.dart';

class ExternalDonationsOverviewUIModel {
  const ExternalDonationsOverviewUIModel({
    required this.currentDonations,
    required this.pastDonations,
    required this.isLoading,
  });

  final List<ExternalDonation> currentDonations;
  final List<ExternalDonation> pastDonations;
  final bool isLoading;

  bool get hasCurrentDonations => currentDonations.isNotEmpty;
  bool get hasPastDonations => pastDonations.isNotEmpty;
  bool get isEmpty => !hasCurrentDonations && !hasPastDonations;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExternalDonationsOverviewUIModel &&
        other.currentDonations == currentDonations &&
        other.pastDonations == pastDonations &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode =>
      Object.hash(currentDonations, pastDonations, isLoading);
}

sealed class ExternalDonationsOverviewCustom {
  const ExternalDonationsOverviewCustom();
}
