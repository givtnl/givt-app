import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  const Goal({
    required this.id,
    required this.goalAmount,
    required this.amount,
    required this.totalAmount,
    required this.mediumId,
    required this.status,
    required this.dateCreated,
    required this.collectGroupId,
  });

  const Goal.empty()
      : this(
          id: '',
          goalAmount: 100,
          amount: 0,
          totalAmount: 0,
          mediumId: '',
          status: FamilyGoalStatus.inProgress,
          collectGroupId: '',
          dateCreated: '2024-01-01T10:00:00Z',
        );

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: (map['id'] ?? '').toString(),
      goalAmount: (map['goal'] as num? ?? 100).toInt(),
      amount: (map['amount'] as num? ?? 0).toDouble(),
      totalAmount: (map['totalAmount'] as num? ?? 0).toDouble(),
      mediumId: map['mediumId'] as String? ?? '',
      collectGroupId: map['collectGroupId'] as String? ?? '',
      status: FamilyGoalStatus.fromString(map['status'] as String),
      dateCreated: map['creationDate'] as String,
    );
  }

  final String id;
  final int goalAmount;
  final double amount;
  final double totalAmount;
  final String mediumId;
  final String collectGroupId;
  final FamilyGoalStatus status;
  final String dateCreated;

  @override
  List<Object?> get props => [
        id,
        goalAmount,
        amount,
        totalAmount,
        mediumId,
        status,
        dateCreated,
        collectGroupId,
      ];
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
