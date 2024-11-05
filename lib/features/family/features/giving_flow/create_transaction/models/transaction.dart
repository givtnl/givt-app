class Transaction {
  const Transaction({
    required this.userId,
    required this.mediumId,
    required this.amount,
    this.goalId,
    this.isActOfService = false,
  });

  final String userId;
  final String mediumId;
  final double amount;
  final String? goalId;
  final bool isActOfService;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'mediumId': mediumId,
      'amount': amount,
      'goalId': goalId,
      'isActOfService': isActOfService,
    };
  }
}
