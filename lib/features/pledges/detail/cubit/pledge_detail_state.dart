part of 'pledge_detail_cubit.dart';

class PledgeDetailUIModel {
  const PledgeDetailUIModel({
    required this.group,
    required this.givenSoFar,
    required this.totalPledged,
    required this.recurringTotal,
    required this.recurringFrequency,
    required this.goalProgress,
    required this.history,
  });

  final PledgeGroup group;
  final double givenSoFar;
  final double? totalPledged;
  final double recurringTotal;
  final String? recurringFrequency;
  final List<PledgeGoalProgress> goalProgress;
  final List<PledgeHistoryItem> history;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PledgeDetailUIModel &&
        other.group == group &&
        other.givenSoFar == givenSoFar &&
        other.totalPledged == totalPledged &&
        other.recurringTotal == recurringTotal &&
        other.recurringFrequency == recurringFrequency &&
        other.goalProgress == goalProgress &&
        other.history == history;
  }

  @override
  int get hashCode => Object.hash(
        group,
        givenSoFar,
        totalPledged,
        recurringTotal,
        recurringFrequency,
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
