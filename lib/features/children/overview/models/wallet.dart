import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/details/models/giving_allowance.dart';

class Wallet extends Equatable {
  const Wallet({
    required this.balance,
    required this.total,
    required this.pending,
    required this.currency,
    required this.pendingAllowance,
    required this.givingAllowance,
  });

  const Wallet.empty()
      : this(
          balance: 0,
          total: 0,
          pending: 0,
          currency: 'USD',
          pendingAllowance: false,
          givingAllowance: const GivingAllowance.empty(),
        );

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      balance: double.parse(map['balance'].toString()),
      total: double.parse(map['total'].toString()),
      pending: double.parse(map['pending'].toString()),
      pendingAllowance: (map['pendingAllowance'] ?? false) as bool,
      currency: map['currency'] as String,
      givingAllowance: map['givingAllowance'] != null
          ? (GivingAllowance.fromMap(
              map['givingAllowance'] as Map<String, dynamic>,
            ))
          : const GivingAllowance.empty(),
    );
  }

  final double balance;
  final double total;
  final double pending;
  final String currency;
  final bool pendingAllowance;
  final GivingAllowance givingAllowance;

  @override
  List<Object?> get props =>
      [balance, total, pending, currency, pendingAllowance, givingAllowance];

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'total': total,
      'pending': pending,
      'currency': currency,
      'pendingAllowance': pendingAllowance,
      'givingAllowance': givingAllowance,
    };
  }
}
