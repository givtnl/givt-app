import 'package:givt_app/features/children/family_history/models/history_item.dart';

class Allowance extends HistoryItem {
  const Allowance({
    required super.amount,
    required super.date,
    required super.type,
    required super.name,
  });

  Allowance.empty()
      : this(
          amount: 0,
          date: DateTime.now(),
          type: HistoryTypes.donation,
          name: '',
        );

  factory Allowance.fromMap(Map<String, dynamic> map) {
    return Allowance(
        name: map['donor']['firstName'].toString(),
        amount: double.tryParse(map['amount'].toString()) ?? 0,
        date:
            DateTime.tryParse(map['donationDate'].toString()) ?? DateTime.now(),
        type: HistoryTypes.values.firstWhere(
          (element) => element.value == map['donationType'],
        ));
  }
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'donationDate': date.toString(),
      'donationType': type.value,
      'donor': {'firstName': name}
    };
  }
}
