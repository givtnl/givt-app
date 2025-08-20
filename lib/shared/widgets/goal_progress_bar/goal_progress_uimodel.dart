class GoalCardProgressUImodel {
  GoalCardProgressUImodel({
    required this.amount,
    this.goalAmount = 100,
    this.totalAmount = 0,
    this.suffix,
  });

  final double amount;
  final int goalAmount;
  final double totalAmount;
  final String? suffix;
}
