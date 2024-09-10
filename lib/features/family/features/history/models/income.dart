import 'package:givt_app/features/family/features/history/models/history_item.dart';

class Income extends HistoryItem {
  const Income({
    required super.amount,
    required super.date,
    required super.type,
  });

  Income.empty()
      : this(
          amount: 0,
          date: DateTime.now(),
          type: HistoryTypes.donation,
        );

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      amount: double.tryParse(map['amount'].toString()) ?? 0,
      date: DateTime.tryParse(map['donationDate'] as String) ?? DateTime.now(),
      type: HistoryTypes.values.firstWhere(
        (element) => element.value == map['donationType'],
      ),
    );
  }

  @override
  List<Object?> get props => [amount, date, type];
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'donationDate': date.toString(),
      'donationType': type.value,
    };
  }
}
