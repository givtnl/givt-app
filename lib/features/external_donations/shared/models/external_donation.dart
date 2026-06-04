import 'package:equatable/equatable.dart';
import 'package:givt_app/core/datetime/api_date_time.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';

/// External (off-platform) donation returned by `GET /externaldonations`.
class ExternalDonation extends Equatable {
  const ExternalDonation({
    required this.id,
    required this.amount,
    required this.description,
    required this.frequencyString,
    required this.creationDate,
    required this.taxDeductible,
    this.startDate,
    this.active = true,
    this.nextRecurringDate,
  });

  factory ExternalDonation.fromJson(Map<String, dynamic> json) {
    return ExternalDonation(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      frequencyString: json['frequency'] as String,
      creationDate: json['creationDate'] as String,
      taxDeductible: json['taxDeductable'] as bool,
      startDate: json['startDate'] as String?,
      active: json['active'] as bool? ?? true,
      nextRecurringDate: json['nextRecurringDate'] as String?,
    );
  }

  const ExternalDonation.empty()
      : id = '',
        amount = 0,
        description = '',
        frequencyString = 'Once',
        creationDate = '',
        taxDeductible = false,
        startDate = null,
        active = true,
        nextRecurringDate = null;

  final String id;
  final double amount;
  final String description;
  final String frequencyString;
  final String creationDate;
  final bool taxDeductible;
  /// Gift date (one-off) or series start (recurring) from the API.
  final String? startDate;
  final bool active;
  final String? nextRecurringDate;

  bool get isOneOff => frequency == ExternalDonationFrequency.once;

  bool get isRecurring => !isOneOff;

  /// Parsed [startDate] as local wall-clock time (gift date or series start).
  DateTime? get startDateTime => ApiDateTime.parseLocal(startDate);

  /// Parsed [creationDate] as local wall-clock time (when the record was created).
  DateTime? get creationDateTime => ApiDateTime.parseLocal(creationDate);

  /// Next scheduled occurrence (`nextRecurringDate`) as local wall-clock time.
  DateTime? get nextRecurringOccurrenceDate =>
      ApiDateTime.parseLocal(nextRecurringDate);

  /// Preferred date for list ordering and one-off subtitles.
  DateTime? get listSortDate => startDateTime ?? creationDateTime;

  ExternalDonationFrequency get frequency {
    switch (frequencyString) {
      case 'Once':
      case 'OneTime':
        return ExternalDonationFrequency.once;
      case 'Weekly':
        return ExternalDonationFrequency.weekly;
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
    return json
        .map(
          (item) => ExternalDonation.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  ExternalDonation copyWith({
    String? id,
    double? amount,
    String? description,
    String? frequencyString,
    String? creationDate,
    bool? taxDeductible,
    String? startDate,
    bool? active,
    String? nextRecurringDate,
    ExternalDonationFrequency? frequency,
  }) {
    var newFrequencyString = frequencyString;
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
      startDate: startDate ?? this.startDate,
      active: active ?? this.active,
      nextRecurringDate: nextRecurringDate ?? this.nextRecurringDate,
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
      case ExternalDonationFrequency.weekly:
        return 'Weekly';
      case ExternalDonationFrequency.once:
        return 'Once';
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
        startDate,
        active,
        nextRecurringDate,
      ];
}
