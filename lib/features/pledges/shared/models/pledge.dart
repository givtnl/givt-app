import 'package:equatable/equatable.dart';
import 'package:givt_app/core/datetime/api_date_time.dart';

/// Collect group on a pledge campaign from `GET /givtservice/v1/Pledge`.
class PledgeCollectGroup extends Equatable {
  const PledgeCollectGroup({
    required this.id,
    required this.namespace,
    required this.name,
  });

  final String id;
  final String namespace;
  final String name;

  @override
  List<Object?> get props => [id, namespace, name];
}

/// A single pledged goal within a pledge group.
class PledgeGoal extends Equatable {
  const PledgeGoal({
    required this.id,
    required this.goalId,
    required this.goalName,
    required this.amount,
    required this.frequency,
    required this.type,
    this.goalAmount,
    this.paidAmount = 0,
    this.nextExecutionDate,
    this.transactions = const [],
  });

  factory PledgeGoal.fromJson(Map<String, dynamic> json) {
    final transactionsJson = json['transactions'] as List<dynamic>? ?? const [];
    return PledgeGoal(
      id: json['id'] as String,
      goalId: json['goalId'] as String,
      goalName: json['goalName'] as String,
      amount: (json['amount'] as num).toDouble(),
      frequency: json['frequency'] as String,
      type: json['type'] as String,
      goalAmount: _parseGoalAmount(json),
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0,
      nextExecutionDate: json['nextExecutionDate'] as String?,
      transactions: transactionsJson
          .map(
            (transaction) =>
                PledgeTransaction.fromJson(transaction as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  static double? _parseGoalAmount(Map<String, dynamic> json) {
    final goalAmount = json['goalAmount'];
    if (goalAmount is num) {
      return goalAmount.toDouble();
    }
    final goal = json['goal'];
    if (goal is num) {
      return goal.toDouble();
    }
    if (goal is Map<String, dynamic>) {
      final nested = goal['goalAmount'] ?? goal['amount'];
      if (nested is num) {
        return nested.toDouble();
      }
    }
    return null;
  }

  bool get isAllAtOncePledge {
    switch (frequency) {
      case 'Once':
      case 'OneTime':
      case 'Yearly':
        return true;
      default:
        return false;
    }
  }

  /// Target for "of €X pledged" and per-goal progress.
  ///
  /// Uses [goalAmount] when the API provides it; for all-at-once pledges the
  /// pledged total is the goal [amount] (e.g. €26 all at once).
  double? get pledgeTargetAmount {
    if (goalAmount != null && goalAmount! > 0) {
      return goalAmount;
    }
    if (isAllAtOncePledge) {
      return amount;
    }
    return null;
  }

  final String id;
  final String goalId;
  final String goalName;
  final double amount;
  final String frequency;
  final String type;
  final double? goalAmount;
  final double paidAmount;
  final String? nextExecutionDate;
  final List<PledgeTransaction> transactions;

  DateTime? get nextExecutionDateTime =>
      ApiDateTime.parseLocal(nextExecutionDate);

  double get givenAmount => transactions
      .where((transaction) => transaction.isProcessed)
      .fold(0, (sum, transaction) => sum + transaction.amount);

  /// Processed transactions, or [paidAmount] when the detail API omits history.
  double get displayGivenAmount {
    if (givenAmount > 0) {
      return givenAmount;
    }
    return paidAmount;
  }

  @override
  List<Object?> get props => [
        id,
        goalId,
        goalName,
        amount,
        frequency,
        type,
        goalAmount,
        paidAmount,
        nextExecutionDate,
        transactions,
      ];
}

/// Transaction linked to a pledged goal (`GET /Pledge/{id}` detail).
class PledgeTransaction extends Equatable {
  const PledgeTransaction({
    required this.id,
    required this.amount,
    required this.donationDate,
    required this.status,
  });

  factory PledgeTransaction.fromJson(Map<String, dynamic> json) {
    return PledgeTransaction(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      donationDate: json['donationDate'] as String,
      status: json['status'] as String,
    );
  }

  final int id;
  final double amount;
  final String donationDate;
  final String status;

  bool get isProcessed => status == 'Processed';

  DateTime? get donationDateTime => ApiDateTime.parseLocal(donationDate);

  @override
  List<Object?> get props => [id, amount, donationDate, status];
}

/// Pledge campaign returned by `GET givtservice/v1/Pledge`.
class PledgeGroup extends Equatable {
  const PledgeGroup({
    required this.pledgeGroupId,
    required this.pledgeGroupName,
    required this.collectGroup,
    required this.startDate,
    required this.endDate,
    required this.goals,
  });

  factory PledgeGroup.fromJson(Map<String, dynamic> json) {
    final goalsJson = json['goals'] as List<dynamic>? ?? const [];
    return PledgeGroup(
      pledgeGroupId: json['pledgeGroupId'] as String,
      pledgeGroupName: json['pledgeGroupName'] as String,
      collectGroup: PledgeCollectGroup(
        id: json['collectGroupId'] as String,
        namespace: json['collectGroupNamespace'] as String,
        name: json['collectGroupName'] as String,
      ),
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      goals: goalsJson
          .map((goal) => PledgeGoal.fromJson(goal as Map<String, dynamic>))
          .toList(),
    );
  }

  static List<PledgeGroup> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => PledgeGroup.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  final String pledgeGroupId;
  final String pledgeGroupName;
  final PledgeCollectGroup collectGroup;
  final String? startDate;
  final String? endDate;
  final List<PledgeGoal> goals;

  DateTime? get startDateTime => ApiDateTime.parseLocal(startDate);

  DateTime? get endDateTime => ApiDateTime.parseLocal(endDate);

  double get givenSoFar =>
      goals.fold(0, (sum, goal) => sum + goal.displayGivenAmount);

  double? get totalPledged {
    if (goals.isEmpty) {
      return null;
    }
    final targets = goals.map((goal) => goal.pledgeTargetAmount).toList();
    if (targets.any((target) => target == null)) {
      return null;
    }
    return targets.fold<double>(0, (sum, target) => sum + target!);
  }

  /// Denominator for the segmented "Given so far" bar (Figma).
  ///
  /// Uses [totalPledged] when every goal has a target; otherwise falls back to
  /// [givenSoFar] so progress is still visible when only paid amounts exist.
  double? get segmentBarTotal {
    final pledged = totalPledged;
    if (pledged != null && pledged > 0) {
      return pledged;
    }
    final given = givenSoFar;
    if (given > 0) {
      return given;
    }
    return null;
  }

  List<Pledge> toPledges() {
    return goals
        .map((goal) => Pledge.fromGroupAndGoal(group: this, goal: goal))
        .toList();
  }

  @override
  List<Object?> get props => [
        pledgeGroupId,
        pledgeGroupName,
        collectGroup,
        startDate,
        endDate,
        goals,
      ];
}

/// Flattened pledge used by the overview list UI.
class Pledge extends Equatable {
  const Pledge({
    required this.id,
    required this.goalId,
    required this.pledgeGroupId,
    required this.type,
    required this.amount,
    required this.frequency,
    required this.collectGroup,
    required this.pledgeGroupName,
    required this.goalName,
    this.goalAmount,
    this.paidAmount = 0,
    this.startDate,
    this.endDate,
    this.nextExecutionDate,
  });

  factory Pledge.fromGroupAndGoal({
    required PledgeGroup group,
    required PledgeGoal goal,
  }) {
    return Pledge(
      id: goal.id,
      goalId: goal.goalId,
      pledgeGroupId: group.pledgeGroupId,
      type: goal.type,
      amount: goal.amount,
      frequency: goal.frequency,
      collectGroup: group.collectGroup,
      pledgeGroupName: group.pledgeGroupName,
      goalName: goal.goalName,
      goalAmount: goal.goalAmount,
      paidAmount: goal.paidAmount,
      startDate: group.startDate,
      endDate: group.endDate,
      nextExecutionDate: goal.nextExecutionDate,
    );
  }

  static List<Pledge> fromApiItems(List<dynamic> jsonList) {
    return PledgeGroup.fromJsonList(jsonList)
        .expand((group) => group.toPledges())
        .toList();
  }

  final String id;
  final String goalId;
  final String pledgeGroupId;
  final String type;
  final double amount;
  final String frequency;
  final PledgeCollectGroup collectGroup;
  final String pledgeGroupName;
  final String goalName;
  final double? goalAmount;
  final double paidAmount;
  final String? startDate;
  final String? endDate;
  final String? nextExecutionDate;

  DateTime? get startDateTime => ApiDateTime.parseLocal(startDate);

  DateTime? get endDateTime => ApiDateTime.parseLocal(endDate);

  DateTime? get nextExecutionDateTime =>
      ApiDateTime.parseLocal(nextExecutionDate);

  @override
  List<Object?> get props => [
        id,
        goalId,
        pledgeGroupId,
        type,
        amount,
        frequency,
        collectGroup,
        pledgeGroupName,
        goalName,
        goalAmount,
        paidAmount,
        startDate,
        endDate,
        nextExecutionDate,
      ];
}

/// One overview list card: a pledge campaign with one or more goals combined.
class PledgeOverviewCard extends Equatable {
  const PledgeOverviewCard({required this.pledges});

  factory PledgeOverviewCard.fromPledges(List<Pledge> pledges) {
    assert(pledges.isNotEmpty, 'PledgeOverviewCard requires at least one pledge');
    return PledgeOverviewCard(pledges: pledges);
  }

  final List<Pledge> pledges;

  Pledge get representative => pledges.first;

  String get pledgeGroupId => representative.pledgeGroupId;

  String get pledgeGroupName => representative.pledgeGroupName;

  PledgeCollectGroup get collectGroup => representative.collectGroup;

  double get totalAmount =>
      pledges.fold(0, (sum, pledge) => sum + pledge.amount);

  double get totalPaid =>
      pledges.fold(0, (sum, pledge) => sum + pledge.paidAmount);

  double? get totalTarget {
    var sum = 0.0;
    for (final pledge in pledges) {
      final target = pledge.goalAmount != null && pledge.goalAmount! > 0
          ? pledge.goalAmount!
          : pledge.isAllAtOncePledge
              ? pledge.amount
              : null;
      if (target == null) {
        return null;
      }
      sum += target;
    }
    return sum > 0 ? sum : null;
  }

  String? get sharedFrequency {
    if (pledges.isEmpty) {
      return null;
    }
    final frequency = pledges.first.frequency;
    for (final pledge in pledges) {
      if (pledge.frequency != frequency) {
        return null;
      }
    }
    return frequency;
  }

  DateTime? get earliestNextExecution {
    DateTime? earliest;
    for (final pledge in pledges) {
      final date = pledge.nextExecutionDateTime;
      if (date == null) {
        continue;
      }
      if (earliest == null || date.isBefore(earliest)) {
        earliest = date;
      }
    }
    return earliest;
  }

  @override
  List<Object?> get props => [pledges];
}

extension PledgeAllAtOnce on Pledge {
  bool get isAllAtOncePledge {
    switch (frequency) {
      case 'Once':
      case 'OneTime':
      case 'Yearly':
        return true;
      default:
        return false;
    }
  }
}
