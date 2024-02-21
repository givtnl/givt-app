import 'package:equatable/equatable.dart';

class FamilyGoal extends Equatable {
  const FamilyGoal({
    required this.goalAmount,
    required this.amount,
    required this.mediumId,
    required this.status,
    required this.dateCreated,
  });

  const FamilyGoal.empty()
      : this(
          goalAmount: 0,
          amount: 0,
          mediumId: '',
          status: FamilyGoalStatus.inProgress,
          dateCreated: '2024-01-01T10:00:00Z',
        );

  factory FamilyGoal.fromMap(Map<String, dynamic> map) {
    return FamilyGoal(
      goalAmount: map['goal'] as int,
      amount: (map['amount'] as int).toDouble(),
      mediumId: map['mediumId'] as String,
      status: FamilyGoalStatus.fromString(map['status'] as String),
      dateCreated: map['dtCreated'] as String,
    );
  }

  final int goalAmount;
  final double amount;
  final String mediumId;
  final FamilyGoalStatus status;
  final String dateCreated;

  @override
  List<Object?> get props =>
      [goalAmount, amount, mediumId, status, dateCreated];
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
