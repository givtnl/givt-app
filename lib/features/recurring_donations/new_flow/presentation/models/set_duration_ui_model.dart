import 'package:equatable/equatable.dart';

class SetDurationUIModel extends Equatable {
  const SetDurationUIModel({
    this.startDate,
    this.selectedOption,
    this.numberOfDonations = '',
    this.endDate,
    this.isLoading = false,
    this.error,
    this.isContinueEnabled = false,
    this.frequencyData = const {},
  });

  final DateTime? startDate;
  final String? selectedOption;
  final String numberOfDonations;
  final DateTime? endDate;
  final bool isLoading;
  final String? error;
  final bool isContinueEnabled;
  final Map<String, dynamic> frequencyData;

  Map<String, dynamic> get analyticsParams => {
        'startDate': startDate?.toIso8601String() ?? '',
        'selectedOption': selectedOption ?? '',
        'numberOfDonations': numberOfDonations,
        'endDate': endDate?.toIso8601String() ?? '',
      };

  SetDurationUIModel copyWith({
    DateTime? startDate,
    String? selectedOption,
    String? numberOfDonations,
    DateTime? endDate,
    bool? isLoading,
    String? error,
    bool? isContinueEnabled,
    Map<String, dynamic>? frequencyData,
  }) {
    return SetDurationUIModel(
      startDate: startDate ?? this.startDate,
      selectedOption: selectedOption ?? this.selectedOption,
      numberOfDonations: numberOfDonations ?? this.numberOfDonations,
      endDate: endDate ?? this.endDate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isContinueEnabled: isContinueEnabled ?? this.isContinueEnabled,
      frequencyData: frequencyData ?? this.frequencyData,
    );
  }

  @override
  List<Object?> get props => [
        startDate,
        selectedOption,
        numberOfDonations,
        endDate,
        isLoading,
        error,
        isContinueEnabled,
        frequencyData
      ];
}
