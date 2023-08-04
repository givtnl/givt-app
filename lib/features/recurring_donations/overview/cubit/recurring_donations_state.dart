part of 'recurring_donations_cubit.dart';

abstract class RecurringDonationsState extends Equatable {
  const RecurringDonationsState();

  @override
  List<Object> get props => [];
}

class RecurringDonationsInitialState extends RecurringDonationsState {}

class RecurringDonationsFetchingState extends RecurringDonationsState {}

class RecurringDonationsErrorState extends RecurringDonationsState {
  const RecurringDonationsErrorState({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}

class RecurringDonationsDetailState extends RecurringDonationsState {
  const RecurringDonationsDetailState({
    required this.instances,
    required this.recurringDonations,
  });

  final List<RecurringDonationDetail> instances;
  final List<RecurringDonation> recurringDonations;
  @override
  List<Object> get props => [instances, recurringDonations];
}

class RecurringDonationsFetchedState extends RecurringDonationsState {
  const RecurringDonationsFetchedState({required this.recurringDonations});

  final List<RecurringDonation> recurringDonations;

  List<RecurringDonation> get activeRecurringDonations {
    return recurringDonations
        .where(
          (element) => element.currentState == RecurringDonationState.active,
        )
        .toList();
  }

  bool get isNoActiveReccuringDonations {
    return activeRecurringDonations.isEmpty;
  }

  @override
  List<Object> get props => [recurringDonations];
}
