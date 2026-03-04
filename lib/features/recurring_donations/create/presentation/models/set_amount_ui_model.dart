import 'package:equatable/equatable.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart' as overview;

class SetAmountUIModel extends Equatable {
  const SetAmountUIModel({
    this.selectedFrequency,
    this.amount = '',
    this.isLoading = false,
    this.error,
  });

  final overview.Frequency? selectedFrequency;
  final String amount;
  final bool isLoading;
  final String? error;

  bool get isContinueEnabled {
    final normalizedAmount = amount.replaceAll(',', '.');
    return selectedFrequency != null &&
        amount.isNotEmpty &&
        double.tryParse(normalizedAmount) != null &&
        double.parse(normalizedAmount) > 0;
  }

  SetAmountUIModel copyWith({
    overview.Frequency? selectedFrequency,
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