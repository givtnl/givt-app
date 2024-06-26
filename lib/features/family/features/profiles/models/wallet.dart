import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  const Wallet({
    required this.balance,
    required this.total,
    required this.pending,
    required this.currency,
  });

  const Wallet.empty()
      : this(balance: 0, total: 0, pending: 0, currency: 'USD');

  final double balance;
  final double total;
  final double pending;
  final String currency;

  @override
  List<Object?> get props => [balance, total, pending, currency];

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      balance: double.parse(map['balance'].toString()),
      total: double.parse(map['total'].toString()),
      pending: double.parse(map['pending'].toString()),
      currency: map['currency'] as String? ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'total': total,
      'pending': pending,
      'currency': currency,
    };
  }
}
