import 'package:givt_app/features/children/family_history/models/history_item.dart';

class Allowance extends HistoryItem {
  const Allowance.empty()
      : this(
          amount: 0,
          date: '',
          type: HistoryTypes.allowance,
          name: '',
          status: AllowanceStatus.proccessed,
          attemptNr: 0,
        );

  const Allowance({
    required super.amount,
    required super.date,
    required super.type,
    required super.name,
    required this.status,
    required this.attemptNr,
  });

  factory Allowance.fromMap(Map<String, dynamic> map) {
    return Allowance(
      name: (map['donor'] as Map<String, dynamic>)['firstName'].toString(),
      amount: double.tryParse(map['amount'].toString()) ?? 0,
      date: map['donationDate'].toString(),
      type: HistoryTypes.fromString(
        map['donationType'] == null ? '' : map['donationType'] as String,
      ),
      status: AllowanceStatus.fromString(
        map['status'] == null ? '' : map['status'] as String,
      ),
      attemptNr: int.tryParse(map['attempts'].toString()) ?? 0,
    );
  }
  final int attemptNr;
  final AllowanceStatus status;

  bool get isNotSuccessful =>
      status != AllowanceStatus.proccessed && attemptNr > 0;
}

enum AllowanceStatus {
  entered('Entered'),
  proccessed('Processed'),
  rejected('Rejected');

  const AllowanceStatus(this.value);

  final String value;

  static AllowanceStatus fromString(String value) {
    return AllowanceStatus.values.firstWhere(
      (element) => element.value == value,
      orElse: () => AllowanceStatus.proccessed,
    );
  }
}
