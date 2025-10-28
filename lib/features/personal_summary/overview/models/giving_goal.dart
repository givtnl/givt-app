import 'package:equatable/equatable.dart';

enum GivingGoalFrequency {
  monthly,
  annually,
}

class GivingGoal extends Equatable {
  const GivingGoal({
    required this.amount,
    required this.frequency,
  });

  const GivingGoal.empty()
      : amount = 0,
        frequency = GivingGoalFrequency.monthly;

  factory GivingGoal.fromJson(Map<String, dynamic> json) {
    final raw = json['frequency'];
    final freqStr = raw is String ? raw.toLowerCase() : 'monthly';
    final freq = freqStr == 'annually'
        ? GivingGoalFrequency.annually
        : GivingGoalFrequency.monthly;
    return GivingGoal(
      amount: json['amount'] as int,
      frequency: freq,
    );
  }

  final int amount;
  final GivingGoalFrequency frequency;

  double get monthlyGivingGoal {
    if (isMonthly) {
      return amount.toDouble();
    }
    return amount.toDouble() / 12;
  }

  double get yearlyGivingGoal {
    if (isAnnually) {
      return amount.toDouble();
    }
    return amount.toDouble() * 12;
  }

  bool get isMonthly => frequency == GivingGoalFrequency.monthly;
  bool get isAnnually => frequency == GivingGoalFrequency.annually;

  GivingGoal copyWith({
    int? amount,
    GivingGoalFrequency? frequency,
  }) {
    return GivingGoal(
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'frequency':
          frequency == GivingGoalFrequency.annually ? 'Annually' : 'Monthly',
    };
  }

  @override
  List<Object?> get props => [amount, frequency];

  @override
  String toString() {
    return 'GivingGoal{amount: $amount, frequency: $frequency}';
  }
}
