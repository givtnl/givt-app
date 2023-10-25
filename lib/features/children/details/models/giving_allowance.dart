import 'package:equatable/equatable.dart';

class GivingAllowance extends Equatable {
  const GivingAllowance({
    required this.amount,
    required this.nextGivingAllowanceDate,
  });

  const GivingAllowance.empty()
      : this(
          amount: 0,
          nextGivingAllowanceDate: '',
        );

  factory GivingAllowance.fromMap(Map<String, dynamic> map) {
    return GivingAllowance(
      amount: num.parse(map['amount'].toString()),
      nextGivingAllowanceDate: map['nextGivingAllowance'] as String,
    );
  }

  final num amount;
  final String nextGivingAllowanceDate;

  @override
  List<Object?> get props => [amount, nextGivingAllowanceDate];

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'nextGivingAllowance': nextGivingAllowanceDate,
    };
  }
}
