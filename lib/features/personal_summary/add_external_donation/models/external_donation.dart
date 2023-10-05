import 'package:equatable/equatable.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';

class ExternalDonation extends Equatable {
  const ExternalDonation({
    required this.id,
    required this.amount,
    required this.description,
    required this.cronExpression,
    required this.creationDate,
    required this.taxDeductible,
  });

  factory ExternalDonation.fromJson(Map<String, dynamic> json) =>
      ExternalDonation(
        id: json['id'] as String,
        amount: json['amount'] as double,
        description: json['description'] as String,
        cronExpression: json['cronExpression'] as String,
        creationDate: json['creationDate'] as String,
        taxDeductible: json['taxDeductable'] as bool,
      );

  const ExternalDonation.empty()
      : id = '',
        amount = 0,
        description = '',
        cronExpression = '',
        creationDate = '',
        taxDeductible = false;

  final String id;
  final double amount;
  final String description;
  final String cronExpression;
  final String creationDate;
  final bool taxDeductible;

  ExternalDonationFrequency get frequency {
    if (cronExpression.isEmpty) {
      return ExternalDonationFrequency.once;
    }
    var cronExp = cronExpression.split(' ')[3];
    if (cronExp.contains('/')) {
      cronExp = cronExp.split('/')[1];
    }
    switch (cronExp) {
      case '1':
        return ExternalDonationFrequency.monthly;
      case '3':
        return ExternalDonationFrequency.quarterly;
      case '6':
        return ExternalDonationFrequency.halfYearly;
      case '12':
        return ExternalDonationFrequency.yearly;
      default:
        return ExternalDonationFrequency.once;
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'amount': amount,
        'description': description,
        'cronExpression': cronExpression,
        'creationDate': creationDate,
        'taxDeductable': taxDeductible,
      };

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
    String? cronExpression,
    String? creationDate,
    bool? taxDeductible,
    ExternalDonationFrequency? frequency,
  }) {
    if (frequency != null &&
        frequency != this.frequency &&
        cronExpression == null) {
      cronExpression = _createCronExpressionByFrequency(
        ExternalDonationFrequency.values.indexOf(frequency),
      );
    }
    return ExternalDonation(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      cronExpression: cronExpression ?? this.cronExpression,
      creationDate: creationDate ?? this.creationDate,
      taxDeductible: taxDeductible ?? this.taxDeductible,
    );
  }

  String _createCronExpressionByFrequency(int frequencyIndex) {
    final startDate = DateTime.now();
    switch (frequencyIndex) {
      case 1: //Monthly
        return '0 0 ${startDate.day} * *';
      case 2: // 3 monthly
        return '0 0 ${startDate.day} ${_getQuarterlyCronFirstPart(startDate.month)}/3 *';
      case 3: // 6 monthly
        return '0 0 ${startDate.day} ${_getHalfYearlyCronFirstPart(startDate.month)}/6 *';
      case 4: // yearly
        return '0 0 ${startDate.day} ${startDate.month + 1} *';
      default: // Once
        return '';
    }
  }

  int _getQuarterlyCronFirstPart(int month) {
    switch (month) {
      case 0:
      case 3:
      case 6:
      case 9:
        return 1;
      case 1:
      case 4:
      case 7:
      case 10:
        return 2;
      case 2:
      case 5:
      case 8:
      case 11:
        return 3;
      default:
        return 0;
    }
  }

  int _getHalfYearlyCronFirstPart(int month) {
    if (month < 7) {
      return month + 1;
    } else {
      return month - 5;
    }
  }

  String _getDayOfWeek(int dayOfWeek) {
    switch (dayOfWeek) {
      case DateTime.monday:
        return 'MON';
      case DateTime.tuesday:
        return 'TUE';
      case DateTime.wednesday:
        return 'WED';
      case DateTime.thursday:
        return 'THU';
      case DateTime.friday:
        return 'FRI';
      case DateTime.saturday:
        return 'SAT';
      case DateTime.sunday:
        return 'SUN';
      default:
        return 'MON';
    }
  }

  @override
  List<Object?> get props =>
      [id, amount, description, cronExpression, creationDate, taxDeductible];
}
