class FamilyGoal {
  const FamilyGoal({
    required this.mediumId,
    required this.amount,
  });

  final String mediumId;
  final num amount;

  Map<String, dynamic> toJson() {
    return {
      'mediumId': mediumId,
      'goal': amount,
    };
  }
}
