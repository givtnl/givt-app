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

/// Wallet donation linked to a pledged goal (detail API only).
class PledgeDonation extends Equatable {
  const PledgeDonation({
    required this.id,
    required this.amount,
    required this.donationDate,
    required this.status,
  });

  factory PledgeDonation.fromJson(Map<String, dynamic> json) {
    return PledgeDonation(
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

/// Scheduled pledge transaction from the pledge API.
class PledgeTransaction extends Equatable {
  const PledgeTransaction({
    required this.id,
    required this.amount,
    required this.executionDate,
    required this.state,
  });

  factory PledgeTransaction.fromJson(Map<String, dynamic> json) {
    return PledgeTransaction(
      id: json['id'].toString(),
      amount: (json['amount'] as num).toDouble(),
      executionDate: (json['executionDate'] ?? json['donationDate']) as String,
      state: parseState(json['state'] ?? json['status']),
    );
  }

  /// Maps [PledgeTransactionState] from the pledge API (string or int).
  static String parseState(dynamic raw) {
    if (raw is int) {
      return switch (raw) {
        2 => 'Processed',
        3 => 'Canceled',
        _ => 'Entered',
      };
    }

    final value = raw?.toString();
    return switch (value) {
      'Processed' || '2' => 'Processed',
      'Canceled' || '3' => 'Canceled',
      'Entered' || '1' || null || '' => 'Entered',
      _ => value,
    };
  }

  final String id;
  final double amount;
  final String executionDate;
  final String state;

  bool get isProcessed => state == 'Processed';

  bool get isEntered => state == 'Entered';

  bool get isCanceled => state == 'Canceled';

  /// Entered or Processed; canceled pledge transactions are excluded from counts.
  bool get isScheduled => isEntered || isProcessed;

  DateTime? get executionDateTime => ApiDateTime.parseLocal(executionDate);

  @override
  List<Object?> get props => [id, amount, executionDate, state];
}

/// A single pledged goal within a pledge group.
class PledgeGoal extends Equatable {
  const PledgeGoal({
    required this.id,
    required this.goalId,
    required this.goalName,
    required this.totalAmount,
    required this.type,
    this.frequency,
    this.transactions = const [],
    this.donations = const [],
  });

  factory PledgeGoal.fromJson(Map<String, dynamic> json) {
    final transactionsJson = json['transactions'] as List<dynamic>? ?? const [];
    final donationsJson = json['donations'] as List<dynamic>? ?? const [];
    final transactions = transactionsJson
        .map(
          (transaction) =>
              PledgeTransaction.fromJson(transaction as Map<String, dynamic>),
        )
        .toList();
  final donations = donationsJson
        .map(
          (donation) =>
              PledgeDonation.fromJson(donation as Map<String, dynamic>),
        )
        .toList();

    final totalAmount = _parseTotalAmount(json);
    final frequency = json['frequency'] as String? ??
        _inferFrequency(transactions);

    return PledgeGoal(
      id: json['id'] as String,
      goalId: json['goalId'] as String,
      goalName: json['goalName'] as String,
      totalAmount: totalAmount,
      type: json['type'] as String,
      frequency: frequency,
      transactions: transactions,
      donations: donations,
    );
  }

  static double _parseTotalAmount(Map<String, dynamic> json) {
    final totalAmount = json['totalAmount'];
    if (totalAmount is num) {
      return totalAmount.toDouble();
    }
    final amount = json['amount'];
    if (amount is num) {
      return amount.toDouble();
    }
    return 0;
  }

  static String? _inferFrequency(List<PledgeTransaction> transactions) {
    final active = transactions
        .where(
          (transaction) =>
              transaction.isEntered || transaction.isProcessed,
        )
        .toList()
      ..sort(
        (a, b) => (a.executionDateTime ?? DateTime(0))
            .compareTo(b.executionDateTime ?? DateTime(0)),
      );

    if (active.length <= 1) {
      return active.isEmpty ? null : 'Once';
    }

    final intervals = <int>[];
    for (var index = 1; index < active.length; index++) {
      final previous = active[index - 1].executionDateTime;
      final current = active[index].executionDateTime;
      if (previous == null || current == null) {
        continue;
      }
      intervals.add(current.difference(previous).inDays.abs());
    }
    if (intervals.isEmpty) {
      return null;
    }

    final averageDays = intervals.reduce((a, b) => a + b) / intervals.length;
    if (averageDays <= 10) {
      return 'Weekly';
    }
    if (averageDays <= 45) {
      return 'Monthly';
    }
    if (averageDays <= 120) {
      return 'Quarterly';
    }
    if (averageDays <= 240) {
      return 'HalfYearly';
    }
    return 'Yearly';
  }

  final String id;
  final String goalId;
  final String goalName;
  final double totalAmount;
  final String type;
  final String? frequency;
  final List<PledgeTransaction> transactions;
  final List<PledgeDonation> donations;

  /// Amount of the earliest upcoming scheduled transaction.
  double? get upcomingInstallmentAmount =>
      _earliestUpcomingTransaction()?.amount;

  /// Per-occurrence amount for recurring display (next upcoming payment).
  double get installmentAmount {
    final upcoming = upcomingInstallmentAmount;
    if (upcoming != null) {
      return upcoming;
    }
    if (transactions.length == 1) {
      return transactions.first.amount;
    }
    if (isAllAtOncePledge && totalAmount > 0) {
      return totalAmount;
    }
    return 0;
  }

  PledgeTransaction? _earliestUpcomingTransaction() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    PledgeTransaction? earliest;
    for (final transaction in transactions) {
      if (!transaction.isEntered) {
        continue;
      }
      final date = transaction.executionDateTime;
      if (date == null) {
        continue;
      }
      final dateOnly = DateTime(date.year, date.month, date.day);
      if (dateOnly.isBefore(today)) {
        continue;
      }
      final earliestDate = earliest?.executionDateTime;
      if (earliest == null ||
          (earliestDate != null && date.isBefore(earliestDate))) {
        earliest = transaction;
      }
    }
    return earliest;
  }

  /// Alias kept for display code that referenced per-installment [amount].
  double get amount => installmentAmount;

  bool get isAllAtOncePledge {
    switch (frequency) {
      case 'Once':
      case 'OneTime':
      case 'Yearly':
        return true;
      case null:
        return transactions.length <= 1;
      default:
        return false;
    }
  }

  /// Target for "of €X pledged" and per-goal progress.
  double? get pledgeTargetAmount =>
      totalAmount > 0 ? totalAmount : null;

  DateTime? get nextExecutionDateTime =>
      _earliestUpcomingTransaction()?.executionDateTime;

  String? get nextExecutionDate =>
      nextExecutionDateTime?.toUtc().toIso8601String();

  double get scheduledGivenAmount => transactions
      .where((transaction) => transaction.isProcessed)
      .fold(0, (sum, transaction) => sum + transaction.amount);

  double get donationGivenAmount => donations
      .where((donation) => donation.isProcessed)
      .fold(0, (sum, donation) => sum + donation.amount);

  /// Completed scheduled pledge transactions ([PledgeTransaction.isProcessed]).
  int get completedPledgeTransactionCount =>
      transactions.where((transaction) => transaction.isProcessed).length;

  /// Scheduled pledge transactions (Entered + Processed; not wallet donations).
  int get totalPledgeTransactionCount =>
      transactions.where((transaction) => transaction.isScheduled).length;

  /// Wallet donations on detail; otherwise processed scheduled transactions.
  double get displayGivenAmount {
    if (donations.isNotEmpty) {
      return donationGivenAmount;
    }
    return scheduledGivenAmount;
  }

  @override
  List<Object?> get props => [
        id,
        goalId,
        goalName,
        totalAmount,
        frequency,
        type,
        transactions,
        donations,
      ];
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

  /// All scheduled pledge transactions across goals (non-canceled in API).
  int get totalTransactionCount => goals.fold(
        0,
        (sum, goal) => sum + goal.totalPledgeTransactionCount,
      );

  /// Scheduled pledge transactions with [PledgeTransaction.isProcessed] state.
  int get completedTransactionCount => goals.fold(
        0,
        (sum, goal) => sum + goal.completedPledgeTransactionCount,
      );

  /// Denominator for the segmented "Given so far" bar (Figma).
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

  /// Sum of upcoming installment amounts on the group's earliest next date.
  double? get upcomingRecurringTotal {
    DateTime? earliestDate;
    for (final goal in goals) {
      final date = goal.nextExecutionDateTime;
      if (date == null) {
        continue;
      }
      if (earliestDate == null || date.isBefore(earliestDate)) {
        earliestDate = date;
      }
    }
    if (earliestDate == null) {
      return null;
    }

    final targetDay = DateTime(
      earliestDate.year,
      earliestDate.month,
      earliestDate.day,
    );
    var sum = 0.0;
    var hasAmount = false;
    for (final goal in goals) {
      final date = goal.nextExecutionDateTime;
      if (date == null) {
        continue;
      }
      final goalDay = DateTime(date.year, date.month, date.day);
      if (goalDay != targetDay) {
        continue;
      }
      final amount = goal.upcomingInstallmentAmount;
      if (amount == null) {
        continue;
      }
      sum += amount;
      hasAmount = true;
    }
    return hasAmount ? sum : null;
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
    required this.collectGroup,
    required this.pledgeGroupName,
    required this.goalName,
    this.frequency,
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
      amount: goal.installmentAmount,
      frequency: goal.frequency,
      collectGroup: group.collectGroup,
      pledgeGroupName: group.pledgeGroupName,
      goalName: goal.goalName,
      goalAmount: goal.totalAmount,
      paidAmount: goal.displayGivenAmount,
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
  final String? frequency;
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

  /// Sum of upcoming installment amounts on the card's earliest next date.
  double get upcomingAmount {
    final nextDate = earliestNextExecution;
    if (nextDate == null) {
      return totalAmount;
    }
    final targetDay = DateTime(
      nextDate.year,
      nextDate.month,
      nextDate.day,
    );
    return pledges
        .where((pledge) {
          final date = pledge.nextExecutionDateTime;
          if (date == null) {
            return false;
          }
          final pledgeDay = DateTime(date.year, date.month, date.day);
          return pledgeDay == targetDay;
        })
        .fold(0, (sum, pledge) => sum + pledge.amount);
  }

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
    if (frequency == null) {
      return null;
    }
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
      case null:
        return false;
      default:
        return false;
    }
  }
}
