import 'package:givt_app/features/children/family_history/models/history_item.dart';

class Topup extends HistoryItem {
  const Topup({
    required super.amount,
    required super.date,
    required super.type,
    required super.name,
    required this.status,
    required this.attemptNr,
  });
  const Topup.empty()
      : this(
          amount: 0,
          date: '',
          type: HistoryTypes.topUp,
          name: '',
          status: HistoryItemStatus.proccessed,
          attemptNr: 0,
        );

  factory Topup.fromMap(Map<String, dynamic> map) {
    return Topup(
      name: (map['donor'] as Map<String, dynamic>)['firstName'].toString(),
      amount: double.tryParse(map['amount'].toString()) ?? 0,
      date: map['donationDate'].toString(),
      type: HistoryTypes.fromString(
        map['donationType'].toString(),
      ),
      status: HistoryItemStatus.fromString(
        map['status'].toString(),
      ),
      attemptNr: int.tryParse(map['attempts'].toString()) ?? 0,
    );
  }
  final int attemptNr;
  final HistoryItemStatus status;

  bool get isNotSuccessful =>
      (status != HistoryItemStatus.proccessed && attemptNr > 0) ||
      status == HistoryItemStatus.cancelled;
}
