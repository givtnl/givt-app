import 'package:givt_app/features/family/features/family_history/models/history_item.dart';

class Income extends HistoryItem {
  const Income({
    required super.amount,
    required super.date,
    required super.type,
  });

  const Income.empty()
      : this(
          amount: 0,
          date: '',
          type: HistoryTypes.donation,
        );

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      amount: double.tryParse(map['amount'].toString()) ?? 0,
      date: map['donationDate'].toString(),
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
      'donationDate': date,
      'donationType': type.value,
    };
  }
}
