import 'package:equatable/equatable.dart';

class ConfirmUIModel extends Equatable {
  const ConfirmUIModel({
    this.organizationName = '',
    this.amount = '',
    this.frequency = '',
    this.startDate,
    this.endDate,
    this.numberOfDonations = '',
    this.selectedEndOption = '',
    this.isLoading = false,
    this.error,
  });

  final String organizationName;
  final String amount;
  final String frequency;
  final DateTime? startDate;
  final DateTime? endDate;
  final String numberOfDonations;
  final String selectedEndOption;
  final bool isLoading;
  final String? error;

  Map<String, dynamic> get analyticsParams => {
        'organization': organizationName,
        'amount': amount,
        'frequency': frequency,
        'startDate': startDate?.toIso8601String() ?? '',
        'endDate': endDate?.toIso8601String() ?? '',
        'numberOfDonations': numberOfDonations,
        'selectedEndOption': selectedEndOption,
      };

  ConfirmUIModel copyWith({
    String? organizationName,
    String? amount,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
    String? numberOfDonations,
    String? selectedEndOption,
    bool? isLoading,
    String? error,
  }) {
    return ConfirmUIModel(
      organizationName: organizationName ?? this.organizationName,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      numberOfDonations: numberOfDonations ?? this.numberOfDonations,
      selectedEndOption: selectedEndOption ?? this.selectedEndOption,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        organizationName,
        amount,
        frequency,
        startDate,
        endDate,
        numberOfDonations,
        selectedEndOption,
        isLoading,
        error,
      ];
} 