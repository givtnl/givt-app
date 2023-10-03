part of 'create_recurring_donation_cubit.dart';

enum CreateRecurringDonationStatus {
  initial,
  loading,
  fieldChanged,
  amountTooLow,
  amountTooHigh,
  amountTooHighConfirmed,
  notInternet,
  duplicateDonation,
  success,
  error
}

class CreateRecurringDonationState extends Equatable {
  const CreateRecurringDonationState({
    required this.startDate,
    required this.endDate,
    this.status = CreateRecurringDonationStatus.initial,
    this.recipient = const CollectGroup.empty(),
    this.frequency = RecurringDonationFrequency.week,
    this.amount = 0,
    this.turns = 1,
    this.showSuccessScreen = false,
  });

  final CreateRecurringDonationStatus status;
  final CollectGroup recipient;
  final RecurringDonationFrequency frequency;
  final double amount;
  final int turns;
  final DateTime startDate;
  final DateTime endDate;
  final bool showSuccessScreen;

  CreateRecurringDonationState copyWith({
    CreateRecurringDonationStatus? status,
    CollectGroup? recipient,
    double? amount,
    int? turns,
    DateTime? startDate,
    DateTime? endDate,
    RecurringDonationFrequency? frequency,
    bool? showSuccessScreen,
  }) {
    return CreateRecurringDonationState(
      status: status ?? this.status,
      recipient: recipient ?? this.recipient,
      amount: amount ?? this.amount,
      turns: turns ?? this.turns,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      frequency: frequency ?? this.frequency,
      showSuccessScreen: showSuccessScreen ?? this.showSuccessScreen,
    );
  }

  @override
  List<Object?> get props => [
        status,
        recipient,
        amount,
        turns,
        startDate,
        endDate,
        frequency,
        showSuccessScreen,
      ];
}
