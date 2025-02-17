class Transaction {
  const Transaction({
    required this.userId,
    required this.mediumId,
    required this.amount,
    this.goalId,
    this.isActOfService = false,
    this.gameGuid,
  });

  final String userId;
  final String mediumId;
  final double amount;
  final String? goalId;
  final bool isActOfService;
  final String? gameGuid;
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'mediumId': mediumId,
      'amount': amount,
      'goalId': goalId,
      'isActOfService': isActOfService,
      if (gameGuid != null) 'GameId': gameGuid,
    };
  }
}
