import 'package:equatable/equatable.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';

class ExternalDonation extends Equatable {
  const ExternalDonation({
    required this.id,
    required this.amount,
    required this.description,
    required this.frequencyString,
    required this.creationDate,
    required this.taxDeductible,
    this.active = true,
  });

  factory ExternalDonation.fromJson(Map<String, dynamic> json) {
    return ExternalDonation(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      frequencyString: json['frequency'] as String,
      creationDate: json['creationDate'] as String,
      taxDeductible: json['taxDeductable'] as bool,
      active: json['active'] as bool? ?? true,
    );
  }

  const ExternalDonation.empty()
      : id = '',
        amount = 0,
        description = '',
        frequencyString = 'OneTime',
        creationDate = '',
        taxDeductible = false,
        active = true;

  final String id;
  final double amount;
  final String description;
  final String frequencyString;
  final String creationDate;
  final bool taxDeductible;
  final bool active;

  ExternalDonationFrequency get frequency {
    switch (frequencyString) {
      case 'Monthly':
        return ExternalDonationFrequency.monthly;
      case 'Quarterly':
        return ExternalDonationFrequency.quarterly;
      case 'HalfYearly':
        return ExternalDonationFrequency.halfYearly;
      case 'Yearly':
        return ExternalDonationFrequency.yearly;
      default:
        return ExternalDonationFrequency.once;
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'description': description,
      'frequency': frequencyString,
      'taxDeductable': taxDeductible,
      'active': active,
    };
  }

  static List<ExternalDonation> fromJsonList(List<dynamic> json) {
    final externalDonations = <ExternalDonation>[];
    for (final dynamic item in json) {
      externalDonations.add(
        ExternalDonation.fromJson(
          item as Map<String, dynamic>,
        ),
      );
    }
    return externalDonations;
  }

  ExternalDonation copyWith({
    String? id,
    double? amount,
    String? description,
    String? frequencyString,
    String? creationDate,
    bool? taxDeductible,
    bool? active,
    ExternalDonationFrequency? frequency,
  }) {
    String? newFrequencyString = frequencyString;
    if (frequency != null && frequency != this.frequency) {
      newFrequencyString = frequencyEnumToString(frequency);
    }
    
    return ExternalDonation(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      frequencyString: newFrequencyString ?? this.frequencyString,
      creationDate: creationDate ?? this.creationDate,
      taxDeductible: taxDeductible ?? this.taxDeductible,
      active: active ?? this.active,
    );
  }

  static String frequencyEnumToString(ExternalDonationFrequency frequency) {
    switch (frequency) {
      case ExternalDonationFrequency.monthly:
        return 'Monthly';
      case ExternalDonationFrequency.quarterly:
        return 'Quarterly';
      case ExternalDonationFrequency.halfYearly:
        return 'HalfYearly';
      case ExternalDonationFrequency.yearly:
        return 'Yearly';
      case ExternalDonationFrequency.once:
        return 'OneTime';
    }
  }

  @override
  List<Object?> get props => [
        id,
        amount,
        description,
        frequencyString,
        creationDate,
        taxDeductible,
        active,
      ];
}
