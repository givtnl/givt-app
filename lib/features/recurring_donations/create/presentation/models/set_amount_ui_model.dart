import 'package:equatable/equatable.dart';
import 'package:givt_app/features/recurring_donations/create/models/recurring_donation_frequency.dart';

class SetAmountUIModel extends Equatable {
  const SetAmountUIModel({
    this.selectedFrequency,
    this.amount = '',
    this.isLoading = false,
    this.error,
  });

  final RecurringDonationFrequency? selectedFrequency;
  final String amount;
  final bool isLoading;
  final String? error;

  bool get isContinueEnabled =>
      selectedFrequency != null &&
      amount.isNotEmpty &&
      double.tryParse(amount) != null &&
      double.parse(amount) > 0;

  SetAmountUIModel copyWith({
    RecurringDonationFrequency? selectedFrequency,
    String? amount,
    bool? isLoading,
    String? error,
  }) {
    return SetAmountUIModel(
      selectedFrequency: selectedFrequency ?? this.selectedFrequency,
      amount: amount ?? this.amount,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [selectedFrequency, amount, isLoading, error];
} 