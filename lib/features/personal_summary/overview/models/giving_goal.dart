import 'package:equatable/equatable.dart';

enum GivingGoalFrequency {
  monthly,
  annually,
}

class GivingGoal extends Equatable {
  const GivingGoal({
    required this.amount,
    required this.frequency,
    this.id,
  });

  const GivingGoal.empty()
      : amount = 0,
        frequency = GivingGoalFrequency.monthly,
        id = null;

  factory GivingGoal.fromJson(Map<String, dynamic> json) {
    final raw = json['frequency'];
    final freqStr = raw is String ? raw.toLowerCase() : 'monthly';
    final freq = freqStr.toLowerCase() == 'annually'
        ? GivingGoalFrequency.annually
        : GivingGoalFrequency.monthly;
    return GivingGoal(
      amount: json['amount'] as int,
      frequency: freq,
      id: json['id'] as String?,
    );
  }

  final int amount;
  final GivingGoalFrequency frequency;
  final String? id;

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
    String? id,
  }) {
    return GivingGoal(
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      id: id ?? this.id,
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
  List<Object?> get props => [amount, frequency, id];

  @override
  String toString() {
    return 'GivingGoal{id: $id, amount: $amount, frequency: $frequency}';
  }
}
