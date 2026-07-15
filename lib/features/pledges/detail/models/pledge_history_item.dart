import 'package:equatable/equatable.dart';

class PledgeHistoryGoalLine extends Equatable {
  const PledgeHistoryGoalLine({
    required this.goalName,
    required this.amount,
  });

  final String goalName;
  final double amount;

  @override
  List<Object?> get props => [goalName, amount];
}

class PledgeHistoryItem extends Equatable {
  const PledgeHistoryItem({
    required this.date,
    required this.isUpcoming,
    required this.goalLines,
    this.title,
  });

  final DateTime date;
  final bool isUpcoming;
  final List<PledgeHistoryGoalLine> goalLines;
  final String? title;

  @override
  List<Object?> get props => [date, isUpcoming, goalLines, title];
}
