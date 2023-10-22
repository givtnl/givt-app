import 'package:equatable/equatable.dart';

class GivingGoal extends Equatable {
  const GivingGoal({
    required this.amount,
    required this.periodicity,
  });

  const GivingGoal.empty()
      : amount = 0,
        periodicity = 0;

  factory GivingGoal.fromJson(Map<String, dynamic> json) {
    return GivingGoal(
      amount: json['amount'] as int,
      periodicity: json['periodicity'] as int,
    );
  }

  final int amount;
  final int periodicity;

  GivingGoal copyWith({
    int? amount,
    int? periodicity,
  }) {
    return GivingGoal(
      amount: amount ?? this.amount,
      periodicity: periodicity ?? this.periodicity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'periodicity': periodicity,
    };
  }

  @override
  List<Object?> get props => [amount, periodicity];

  @override
  String toString() {
    return 'GivingGoal{amount: $amount, periodicity: $periodicity}';
  }
}
