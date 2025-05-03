import 'package:equatable/equatable.dart';

class SetDurationUIModel extends Equatable {
  const SetDurationUIModel({
    this.startDate,
    this.endDate,
    this.numberOfDonations = '',
    this.selectedOption,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final String numberOfDonations;
  final String? selectedOption;

  bool get isContinueEnabled {
    if (selectedOption == null) return false;
    switch (selectedOption) {
      case 'When I decide':
        return true;
      case 'After a number of donations':
        return int.tryParse(numberOfDonations) != null &&
            int.parse(numberOfDonations) > 0;
      case 'On a specific date':
        return endDate != null;
      default:
        return false;
    }
  }

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        numberOfDonations,
        selectedOption,
      ];
} 