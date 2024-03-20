import 'package:equatable/equatable.dart';

class FamilyGoal extends Equatable {
  const FamilyGoal({
    required this.id,
    required this.goalAmount,
    required this.amount,
    required this.totalAmount,
    required this.mediumId,
    required this.status,
    required this.dateCreated,
  });

  const FamilyGoal.empty()
      : this(
          id: '',
          goalAmount: 0,
          amount: 0,
          totalAmount: 0,
          mediumId: '',
          status: FamilyGoalStatus.inProgress,
          dateCreated: '2024-01-01T10:00:00Z',
        );

  factory FamilyGoal.fromMap(Map<String, dynamic> map) {
    return FamilyGoal(
      id: (map['id'] ?? '').toString(),
      goalAmount: (map['goal'] as num).toInt(),
      amount: (map['amount'] as num).toDouble(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      mediumId: map['mediumId'] as String,
      status: FamilyGoalStatus.fromString(map['status'] as String),
      dateCreated: map['creationDate'] as String,
    );
  }

  final String id;
  final int goalAmount;
  final double amount;
  final double totalAmount;
  final String mediumId;
  final FamilyGoalStatus status;
  final String dateCreated;

  @override
  List<Object?> get props =>
      [id, goalAmount, amount, totalAmount, mediumId, status, dateCreated];
}

enum FamilyGoalStatus {
  inProgress('InProgress'),
  completed('Completed');

  const FamilyGoalStatus(this.value);

  final String value;

  static FamilyGoalStatus fromString(String value) {
    return FamilyGoalStatus.values.firstWhere(
      (element) => element.value == value,
      orElse: () => FamilyGoalStatus.inProgress,
    );
  }
}
