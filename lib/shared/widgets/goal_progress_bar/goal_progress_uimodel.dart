class GoalCardProgressUImodel {
  GoalCardProgressUImodel({
    required this.amount,
    this.goalAmount = 100,
    this.totalAmount = 0,
    this.suffix,
    this.displayText,
  });

  final double amount;
  final int goalAmount;
  final double totalAmount;
  final String? suffix;

  /// When set, shown as the progress label instead of `amount / totalAmount`.
  final String? displayText;
}
