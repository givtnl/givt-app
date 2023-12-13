import 'package:givt_app/features/children/family_history/models/history_item.dart';

class Allowance extends HistoryItem {
  const Allowance({
    required super.amount,
    required super.date,
    required super.type,
    required super.name,
  });

  const Allowance.empty()
      : this(
          amount: 0,
          date: '',
          type: HistoryTypes.donation,
          name: '',
        );

  factory Allowance.fromMap(Map<String, dynamic> map) {
    return Allowance(
      name: (map['donor'] as Map<String, dynamic>)['firstName'].toString(),
      amount: double.tryParse(map['amount'].toString()) ?? 0,
      date: map['donationDate'].toString(),
      type: HistoryTypes.values.firstWhere(
        (element) => element.value == map['donationType'],
      ),
    );
  }
}
