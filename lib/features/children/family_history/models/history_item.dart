import 'package:equatable/equatable.dart';

abstract class HistoryItem extends Equatable {
  const HistoryItem({
    required this.amount,
    required this.date,
    required this.type,
    required this.name,
  });

  final double amount;
  final DateTime date;
  final HistoryTypes type;
  final String name;

  @override
  List<Object?> get props => [amount, date, type, name];
}

enum HistoryTypes {
  donation('WalletDonation'),
  allowance('RecurringAllowance');

  final String value;
  const HistoryTypes(this.value);
}
