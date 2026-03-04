import 'package:equatable/equatable.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart' as overview;
import 'package:givt_app/features/recurring_donations/create/presentation/constants/string_keys.dart';

class ConfirmUIModel extends Equatable {
  const ConfirmUIModel({
    this.organizationName = '',
    this.amount = '',
    this.frequency,
    this.startDate,
    this.endDate,
    this.numberOfDonations = '',
    this.selectedEndOption = '',
    this.isLoading = false,
  });

  final String organizationName;
  final String amount;
  final overview.Frequency? frequency;
  final DateTime? startDate;
  final DateTime? endDate;
  final String numberOfDonations;
  final String selectedEndOption;
  final bool isLoading;

  Map<String, dynamic> get analyticsParams => {
        'organization': organizationName,
        'amount': amount,
        'frequency': frequency?.name ?? '',
        'startDate': startDate?.toIso8601String() ?? '',
        'endDate': endDate?.toIso8601String() ?? '',
        'numberOfDonations': numberOfDonations,
        'selectedEndOption': selectedEndOption,
        // Technical identifiers for analytics (easier to combine results)
        'endOptionType': _getEndOptionType(),
        'frequencyType': frequency?.name ?? '',
        'amountNumeric': amount.isNotEmpty
            ? double.tryParse(amount.replaceAll(',', '.'))
            : null,
        'hasEndDate': endDate != null,
        'hasNumberOfDonations': numberOfDonations.isNotEmpty,
        'startDateTimestamp': startDate?.millisecondsSinceEpoch,
        'endDateTimestamp': endDate?.millisecondsSinceEpoch,
        // Additional technical parameters
        'frequencyInDays': _getFrequencyInDays(),
        'estimatedTotalDonations': _getEstimatedTotalDonations(),
        'durationInDays': _getDurationInDays(),
        'isIndefinite': selectedEndOption == RecurringDonationStringKeys.whenIDecide,
        'isFixedDuration': selectedEndOption == RecurringDonationStringKeys.afterNumberOfDonations,
        'isFixedEndDate': selectedEndOption == RecurringDonationStringKeys.onSpecificDate,
      };

  /// Returns a technical identifier for the end option type
  String _getEndOptionType() {
    if (selectedEndOption == RecurringDonationStringKeys.whenIDecide) {
      return 'when_i_decide';
    } else if (selectedEndOption == RecurringDonationStringKeys.afterNumberOfDonations) {
      return 'after_number_of_donations';
    } else if (selectedEndOption == RecurringDonationStringKeys.onSpecificDate) {
      return 'on_specific_date';
    }
    return 'unknown';
  }

  /// Returns frequency in days for analytics
  int? _getFrequencyInDays() {
    if (frequency == null) return null;
    
    switch (frequency!) {
      case overview.Frequency.daily:
        return 1;
      case overview.Frequency.weekly:
        return 7;
      case overview.Frequency.monthly:
        return 30;
      case overview.Frequency.quarterly:
        return 90;
      case overview.Frequency.halfYearly:
        return 180;
      case overview.Frequency.yearly:
        return 365;
      case overview.Frequency.none:
        return null;
    }
  }

  /// Returns estimated total number of donations for analytics
  int? _getEstimatedTotalDonations() {
    if (selectedEndOption == RecurringDonationStringKeys.afterNumberOfDonations) {
      return int.tryParse(numberOfDonations);
    } else if (selectedEndOption == RecurringDonationStringKeys.onSpecificDate && 
               startDate != null && endDate != null) {
      final frequencyDays = _getFrequencyInDays();
      if (frequencyDays != null) {
        final durationDays = endDate!.difference(startDate!).inDays;
        return (durationDays / frequencyDays).ceil();
      }
    }
    return null;
  }

  /// Returns duration in days for analytics
  int? _getDurationInDays() {
    if (startDate != null && endDate != null) {
      return endDate!.difference(startDate!).inDays;
    }
    return null;
  }

  ConfirmUIModel copyWith({
    String? organizationName,
    String? amount,
    overview.Frequency? frequency,
    DateTime? startDate,
    DateTime? endDate,
    String? numberOfDonations,
    String? selectedEndOption,
    bool? isLoading,
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
      ];
} 