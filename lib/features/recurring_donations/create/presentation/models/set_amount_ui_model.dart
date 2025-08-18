import 'package:equatable/equatable.dart';

class SetAmountUIModel extends Equatable {
  const SetAmountUIModel({
    this.selectedFrequency,
    this.amount = '',
    this.isLoading = false,
    this.error,
  });

  final String? selectedFrequency;
  final String amount;
  final bool isLoading;
  final String? error;

  bool get isContinueEnabled =>
      (selectedFrequency != null && selectedFrequency!.isNotEmpty) &&
      amount.isNotEmpty &&
      double.tryParse(amount) != null &&
      double.parse(amount) > 0;

  SetAmountUIModel copyWith({
    String? selectedFrequency,
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