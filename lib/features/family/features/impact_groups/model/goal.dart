import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  const Goal({
    required this.goalAmount,
    required this.amount,
    required this.totalAmount,
    required this.mediumId,
    required this.status,
    required this.dateCreated,
    required this.orgName,
    required this.goalId,
  });

  const Goal.empty()
      : this(
          goalAmount: 100,
          amount: 0,
          totalAmount: 0,
          mediumId: '',
          status: GoalStatus.init,
          dateCreated: '2024-01-01T10:00:00Z',
          orgName: '',
          goalId: '',
        );

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      goalAmount: (map['goal'] as num).toInt(),
      amount: (map['amount'] as num).toDouble(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      mediumId: map['mediumId'] as String? ?? '',
      status: GoalStatus.fromString(map['status'] as String),
      dateCreated: map['creationDate'] as String,
      orgName: map['collectGroupName'] as String,
      goalId: map['id'] as String,
    );
  }

  final int goalAmount;
  final double amount;
  final double totalAmount;
  final String mediumId;
  final GoalStatus status;
  final String dateCreated;
  final String orgName;
  final String goalId;

  @override
  List<Object?> get props => [
        goalAmount,
        amount,
        totalAmount,
        mediumId,
        status,
        dateCreated,
        orgName,
        goalId,
      ];

  bool get isActive => status == GoalStatus.inProgress;

  String toJson() {
    return '''
    {
      "goal": $goalAmount,
      "amount": ${amount.toInt()},
      "totalAmount": ${totalAmount.toInt()},
      "mediumId": "$mediumId",
      "status": "${status.value}",
      "creationDate": "$dateCreated",
      "collectGroupName": "$orgName"
      "id": "$goalId"
    }
    ''';
  }

  Goal copyWith({
    int? goalAmount,
    double? amount,
    double? totalAmount,
    String? mediumId,
    GoalStatus? status,
    String? dateCreated,
    String? orgName,
    String? goalId,
  }) {
    return Goal(
      goalAmount: goalAmount ?? this.goalAmount,
      amount: amount ?? this.amount,
      totalAmount: totalAmount ?? this.totalAmount,
      mediumId: mediumId ?? this.mediumId,
      status: status ?? this.status,
      dateCreated: dateCreated ?? this.dateCreated,
      orgName: orgName ?? this.orgName,
      goalId: goalId ?? this.goalId,
    );
  }
}

enum GoalStatus {
  inProgress('InProgress'),
  completed('Completed'),
  updating('Updating'),
  init('Init');

  const GoalStatus(this.value);

  final String value;

  static GoalStatus fromString(String value) {
    return GoalStatus.values.firstWhere(
      (element) => element.value == value,
      orElse: () => GoalStatus.inProgress,
    );
  }
}
