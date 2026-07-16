part of 'pledge_detail_cubit.dart';

class PledgeDetailUIModel {
  const PledgeDetailUIModel({
    required this.group,
    required this.givenSoFar,
    required this.totalPledged,
    required this.completedTransactionCount,
    required this.totalTransactionCount,
    required this.goalProgress,
    required this.history,
  });

  final PledgeGroup group;
  final double givenSoFar;
  final double? totalPledged;
  final int completedTransactionCount;
  final int totalTransactionCount;
  final List<PledgeGoalProgress> goalProgress;
  final List<PledgeHistoryItem> history;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PledgeDetailUIModel &&
        other.group == group &&
        other.givenSoFar == givenSoFar &&
        other.totalPledged == totalPledged &&
        other.completedTransactionCount == completedTransactionCount &&
        other.totalTransactionCount == totalTransactionCount &&
        other.goalProgress == goalProgress &&
        other.history == history;
  }

  @override
  int get hashCode => Object.hash(
        group,
        givenSoFar,
        totalPledged,
        completedTransactionCount,
        totalTransactionCount,
        goalProgress,
        history,
      );
}

class PledgeGoalProgress {
  const PledgeGoalProgress({
    required this.goal,
    required this.given,
    required this.target,
  });

  final PledgeGoal goal;
  final double given;
  final double? target;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PledgeGoalProgress &&
        other.goal == goal &&
        other.given == given &&
        other.target == target;
  }

  @override
  int get hashCode => Object.hash(goal, given, target);
}
