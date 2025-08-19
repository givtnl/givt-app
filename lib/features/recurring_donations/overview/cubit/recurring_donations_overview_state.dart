part of 'recurring_donations_overview_cubit.dart';

/// UI Model for a recurring donation with calculated progress information
class RecurringDonationWithProgress {
  const RecurringDonationWithProgress({
    required this.donation,
    required this.completedTurns,
    required this.remainingTurns,
    required this.progressPercentage,
    required this.isCompleted,
    required this.nextDonationDate,
  });

  final RecurringDonation donation;
  final int completedTurns;
  final int remainingTurns;
  final double progressPercentage;
  final bool isCompleted;
  final DateTime nextDonationDate;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecurringDonationWithProgress &&
        other.donation == donation &&
        other.completedTurns == completedTurns &&
        other.remainingTurns == remainingTurns &&
        other.progressPercentage == progressPercentage &&
        other.isCompleted == isCompleted &&
        other.nextDonationDate == nextDonationDate;
  }

  @override
  int get hashCode {
    return Object.hash(
      donation,
      completedTurns,
      remainingTurns,
      progressPercentage,
      isCompleted,
      nextDonationDate,
    );
  }
}

/// UI Model for the recurring donations overview screen
class RecurringDonationsOverviewUIModel {
  const RecurringDonationsOverviewUIModel({
    required this.currentDonations,
    required this.pastDonations,
    required this.isLoading,
    this.error,
  });

  final List<RecurringDonationWithProgress> currentDonations;
  final List<RecurringDonationWithProgress> pastDonations;
  final bool isLoading;
  final String? error;

  bool get hasCurrentDonations => currentDonations.isNotEmpty;
  bool get hasPastDonations => pastDonations.isNotEmpty;
  bool get hasError => error != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecurringDonationsOverviewUIModel &&
        other.currentDonations == currentDonations &&
        other.pastDonations == pastDonations &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode {
    return Object.hash(
      currentDonations,
      pastDonations,
      isLoading,
      error,
    );
  }
}

/// Custom states for the recurring donations overview cubit
sealed class RecurringDonationsOverviewCustom {
  const RecurringDonationsOverviewCustom();

  const factory RecurringDonationsOverviewCustom.navigateToAddRecurringDonation() = NavigateToAddRecurringDonation;
}

class NavigateToAddRecurringDonation extends RecurringDonationsOverviewCustom {
  const NavigateToAddRecurringDonation();
}
