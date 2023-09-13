part of 'create_recurring_donation_cubit.dart';

enum CreateRecurringDonationStatus {
  initial,
  loading,
  fieldChanged,
  success,
  error
}

class CreateRecurringDonationState extends Equatable {
  const CreateRecurringDonationState({
    this.status = CreateRecurringDonationStatus.initial,
    this.recipient = const CollectGroup.empty(),
    this.amount = 0.0,
    this.turns = 0,
    this.startDate,
    this.endDate,
  });

  final CreateRecurringDonationStatus status;
  final CollectGroup recipient;
  final double amount;
  final int turns;
  final DateTime? startDate;
  final DateTime? endDate;

  CreateRecurringDonationState copyWith({
    CreateRecurringDonationStatus? status,
    CollectGroup? recipient,
    double? amount,
    int? turns,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return CreateRecurringDonationState(
      status: status ?? this.status,
      recipient: recipient ?? this.recipient,
      amount: amount ?? this.amount,
      turns: turns ?? this.turns,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
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
      ];
}
