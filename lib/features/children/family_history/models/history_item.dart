import 'package:equatable/equatable.dart';

abstract class HistoryItem extends Equatable {
  const HistoryItem({
    required this.amount,
    required this.date,
    required this.type,
    required this.name,
  });

  final double amount;
  final String date;
  final HistoryTypes type;
  final String name;

  @override
  List<Object?> get props => [amount, date, type, name];
}

enum HistoryTypes {
  donation('WalletDonation'),
  allowance('RecurringAllowance');

  const HistoryTypes(this.value);

  final String value;

  static HistoryTypes fromString(String value) {
    return HistoryTypes.values.firstWhere(
      (element) => element.value == value,
      orElse: () => HistoryTypes.donation,
    );
  }
}
