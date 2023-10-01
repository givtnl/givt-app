import 'package:equatable/equatable.dart';

class ExternalDonation extends Equatable {
  const ExternalDonation({
    required this.id,
    required this.amount,
    required this.description,
    required this.cronExpression,
    required this.creationDate,
    required this.taxDeductable,
  });

  const ExternalDonation.empty()
      : id = '',
        amount = 0,
        description = '',
        cronExpression = '',
        creationDate = '',
        taxDeductable = false;

  final String id;
  final double amount;
  final String description;
  final String cronExpression;
  final String creationDate;
  final bool taxDeductable;

  factory ExternalDonation.fromJson(Map<String, dynamic> json) =>
      ExternalDonation(
        id: json['id'] as String,
        amount: json['amount'] as double,
        description: json['description'] as String,
        cronExpression: json['cronExpression'] as String,
        creationDate: json['creationDate'] as String,
        taxDeductable: json['taxDeductable'] as bool,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'amount': amount,
        'description': description,
        'cronExpression': cronExpression,
        'creationDate': creationDate,
        'taxDeductable': taxDeductable,
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
    bool? taxDeductable,
  }) {
    return ExternalDonation(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      cronExpression: cronExpression ?? this.cronExpression,
      creationDate: creationDate ?? this.creationDate,
      taxDeductable: taxDeductable ?? this.taxDeductable,
    );
  }

  @override
  List<Object?> get props =>
      [id, amount, description, cronExpression, creationDate, taxDeductable];
}
