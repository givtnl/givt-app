import 'package:equatable/equatable.dart';

class SummaryItem extends Equatable {
  const SummaryItem({
    required this.key,
    required this.amount,
    required this.count,
    required this.taxDeductable,
  });

  factory SummaryItem.fromJson(Map<String, dynamic> json) {
    return SummaryItem(
      key: json['Key'] as String,
      amount: json['Value'] as double,
      count: json['Count'] as double,
      taxDeductable:
          json['TaxDeductable'] == null ? false : json['TaxDeductable'] as bool,
    );
  }
  static List<SummaryItem> fromJsonList(List<dynamic> jsonList) => jsonList
      .map(
        (dynamic json) => SummaryItem.fromJson(
          json as Map<String, dynamic>,
        ),
      )
      .toList();

  final String key;
  final double amount;
  final double count;
  final bool taxDeductable;

  @override
  List<Object> get props => [key, amount, count, taxDeductable];
}
