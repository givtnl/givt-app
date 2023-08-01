import 'package:equatable/equatable.dart';

class MonthlySummaryItem extends Equatable {
  const MonthlySummaryItem({
    required this.organisationName,
    required this.amount,
    required this.count,
    required this.taxDeductable,
  });

  factory MonthlySummaryItem.fromJson(Map<String, dynamic> json) {
    return MonthlySummaryItem(
      organisationName: json['Key'] as String,
      amount: json['Value'] as double,
      count: json['Count'] as double,
      taxDeductable: json['TaxDeductable'] as bool,
    );
  }
  static List<MonthlySummaryItem> fromJsonList(List<dynamic> jsonList) =>
      jsonList
          .map(
            (dynamic json) => MonthlySummaryItem.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();

  final String organisationName;
  final double amount;
  final double count;
  final bool taxDeductable;

  @override
  List<Object> get props => [organisationName, amount, count, taxDeductable];
}
