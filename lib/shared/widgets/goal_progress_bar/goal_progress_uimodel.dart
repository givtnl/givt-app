class GoalProgressUImodel {
  GoalProgressUImodel({
    required this.amount,
    this.goalAmount = 100,
    this.totalAmount = 0,
  });

  final double amount;
  final int goalAmount;
  final double totalAmount;
}
