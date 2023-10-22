import 'package:equatable/equatable.dart';

class SummaryItem extends Equatable {
  const SummaryItem({
    required this.key,
    required this.amount,
    required this.count,
    required this.taxDeductable,
  });

  const SummaryItem.empty()
      : key = '',
        amount = 0,
        count = 0,
        taxDeductable = false;

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

  SummaryItem copyWith({
    String? key,
    double? amount,
    double? count,
    bool? taxDeductable,
  }) =>
      SummaryItem(
        key: key ?? this.key,
        amount: amount ?? this.amount,
        count: count ?? this.count,
        taxDeductable: taxDeductable ?? this.taxDeductable,
      );

  @override
  List<Object> get props => [key, amount, count, taxDeductable];
}
