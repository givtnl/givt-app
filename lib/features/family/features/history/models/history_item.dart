import 'package:equatable/equatable.dart';

abstract class HistoryItem extends Equatable {
  const HistoryItem({
    required this.amount,
    required this.date,
    required this.type,
  });

  final double amount;
  final DateTime date;
  final HistoryTypes type;

  @override
  List<Object?> get props => [amount, date, type];
}

enum HistoryTypes {
  donation('WalletDonation'),
  allowance('RecurringAllowance');

  const HistoryTypes(this.value);

  final String value;
}
