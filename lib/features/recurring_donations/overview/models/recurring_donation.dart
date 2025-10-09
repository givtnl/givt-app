import 'package:equatable/equatable.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:jiffy/jiffy.dart';

enum RecurringDonationState {
  cancelled,
  active,
  finished;

  static RecurringDonationState fromJson(Map<String, dynamic> json) {
    return RecurringDonationState.values[(json['currentState'] as int)];
  }
}

enum Frequency {
  none(0),
  daily(1),
  weekly(2),
  monthly(3),
  yearly(4),
  quarterly(5),
  halfYearly(6);

  const Frequency(this.value);
  final int value;

  static Frequency fromString(String frequency) {
    switch (frequency) {
      case 'Daily':
        return Frequency.daily;
      case 'Weekly':
        return Frequency.weekly;
      case 'Monthly':
        return Frequency.monthly;
      case 'Yearly':
        return Frequency.yearly;
      case 'Quarterly':
        return Frequency.quarterly;
      case 'HalfYearly':
        return Frequency.halfYearly;
      default:
        return Frequency.none;
    }
  }

  String get apiValue {
    switch (this) {
      case Frequency.daily:
        return 'Daily';
      case Frequency.weekly:
        return 'Weekly';
      case Frequency.monthly:
        return 'Monthly';
      case Frequency.yearly:
        return 'Yearly';
      case Frequency.quarterly:
        return 'Quarterly';
      case Frequency.halfYearly:
        return 'HalfYearly';
      case Frequency.none:
        return 'None';
    }
  }

}

class RecurringDonationTransaction {
  const RecurringDonationTransaction({
    required this.id,
    required this.amount,
    required this.status,
  });

  factory RecurringDonationTransaction.fromJson(Map<String, dynamic> json) {
    return RecurringDonationTransaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  final String id;
  final double amount;
  final String status;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'status': status,
    };
  }
}

class RecurringDonation extends Equatable {
  const RecurringDonation({
    required this.id,
    required this.userId,
    required this.amount,
    required this.frequency,
    required this.maxRecurrencies,
    required this.startDate,
    this.endDate,
    required this.currentState,
    required this.creationDateTime,
    required this.collectGroupName,
    this.transactions = const [],
    this.collectGroup = const CollectGroup.empty(),
  });

  factory RecurringDonation.fromJson(Map<String, dynamic> json) =>
      RecurringDonation(
        id: json['id'] as String,
        userId: json['userId'] as String,
        amount: (json['amount'] as num).toDouble(),
        frequency: Frequency.fromString(json['frequency'] as String),
        maxRecurrencies: json['maxRecurrencies'] as int,
        startDate: json['startDate'] as String,
        endDate: json['endDate'] as String?,
        currentState: RecurringDonationState.fromJson(json),
        creationDateTime: json['creationDateTime'] as String,
        collectGroupName: json['collectGroupName'] as String,
        transactions: (json['transactions'] as List<dynamic>?)
                ?.map((e) => RecurringDonationTransaction.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  final String id;
  final String userId;
  final double amount;
  final Frequency frequency;
  final int maxRecurrencies;
  final String startDate;
  final String? endDate;
  final RecurringDonationState currentState;
  final String creationDateTime;
  final String collectGroupName;
  final List<RecurringDonationTransaction> transactions;
  final CollectGroup collectGroup;

  // Legacy properties for backward compatibility
  num get amountPerTurn => amount;
  String get namespace => collectGroupName;
  int get endsAfterTurns => maxRecurrencies;

  RecurringDonation copyWith({
    String? id,
    String? userId,
    double? amount,
    Frequency? frequency,
    int? maxRecurrencies,
    String? startDate,
    String? endDate,
    RecurringDonationState? currentState,
    String? creationDateTime,
    String? collectGroupName,
    List<RecurringDonationTransaction>? transactions,
    CollectGroup? collectGroup,
    // Legacy parameters for backward compatibility
    num? amountPerTurn,
    String? cronExpression,
    int? endsAfterTurns,
    String? namespace,
  }) {
    return RecurringDonation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? amountPerTurn?.toDouble() ?? this.amount,
      frequency: frequency ?? this.frequency,
      maxRecurrencies: maxRecurrencies ?? endsAfterTurns ?? this.maxRecurrencies,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentState: currentState ?? this.currentState,
      creationDateTime: creationDateTime ?? this.creationDateTime,
      collectGroupName: collectGroupName ?? namespace ?? this.collectGroupName,
      transactions: transactions ?? this.transactions,
      collectGroup: collectGroup ?? this.collectGroup,
    );
  }

  int get frequencyValue {
    return frequency.value;
  }

  DateTime? get calculatedEndDate {
    if (endDate != null) {
      return DateTime.parse(endDate!);
    }
    return _evaluateEndDateFromRecurringDonation();
  }

  DateTime? _evaluateEndDateFromRecurringDonation() {
    if (maxRecurrencies <= 0 || maxRecurrencies == 999) {
      return null; // Unlimited or no end date
    }
    
    var startDateDateTime = DateTime.parse(startDate);
    final multiplier = maxRecurrencies - 1;
    
    switch (frequency) {
      case Frequency.daily:
        startDateDateTime = startDateDateTime.add(Duration(days: multiplier));
      case Frequency.weekly:
        startDateDateTime = startDateDateTime.add(Duration(days: 7 * multiplier));
      case Frequency.monthly:
        startDateDateTime = startDateDateTime.copyWith(
          month: startDateDateTime.month + multiplier,
        );
      case Frequency.quarterly:
        startDateDateTime = startDateDateTime.copyWith(
          month: startDateDateTime.month + (3 * multiplier),
        );
      case Frequency.halfYearly:
        startDateDateTime = startDateDateTime.copyWith(
          month: startDateDateTime.month + (6 * multiplier),
        );
      case Frequency.yearly:
        startDateDateTime = startDateDateTime.copyWith(
          year: startDateDateTime.year + multiplier,
        );
      case Frequency.none:
        return null;
    }
    return startDateDateTime;
  }

  DateTime getNextDonationDate(DateTime previousDate) {
    final jiffy = Jiffy.parseFromDateTime(previousDate);

    DateTime nextDonationDate;

    switch (frequency) {
      case Frequency.daily:
        nextDonationDate = jiffy.add(days: 1).dateTime;
      case Frequency.weekly:
        nextDonationDate = jiffy.add(days: 7).dateTime;
      case Frequency.monthly:
        nextDonationDate = jiffy.add(months: 1).dateTime;
      case Frequency.quarterly:
        nextDonationDate = jiffy.add(months: 3).dateTime;
      case Frequency.halfYearly:
        nextDonationDate = jiffy.add(months: 6).dateTime;
      case Frequency.yearly:
        nextDonationDate = jiffy.add(years: 1).dateTime;
      case Frequency.none:
        nextDonationDate = jiffy.dateTime;
    }

    return nextDonationDate;
  }

  /// Gets the next donation date based on the start date and completed turns
  DateTime getNextDonationDateFromStart([DateTime? currentDate]) {
    final now = currentDate ?? DateTime.now();
    final start = DateTime.parse(startDate);
    
    // If current date is before start date, next donation is the start date
    if (now.isBefore(start)) {
      return start;
    }

    final completedTurns = getCompletedTurns(currentDate);
    
    // Calculate the date of the next turn based on start date and completed turns
    var nextDate = start;
    
    switch (frequency) {
      case Frequency.daily:
        nextDate = start.add(Duration(days: completedTurns + 1));
      case Frequency.weekly:
        nextDate = start.add(Duration(days: 7 * (completedTurns + 1)));
      case Frequency.monthly:
        nextDate = start.copyWith(month: start.month + completedTurns + 1);
      case Frequency.quarterly:
        nextDate = start.copyWith(month: start.month + (3 * (completedTurns + 1)));
      case Frequency.halfYearly:
        nextDate = start.copyWith(month: start.month + (6 * (completedTurns + 1)));
      case Frequency.yearly:
        nextDate = start.copyWith(year: start.year + completedTurns + 1);
      case Frequency.none:
        nextDate = start;
    }
    
    return nextDate;
  }

  /// Calculates the number of completed turns based on start date, current date, and frequency
  int getCompletedTurns([DateTime? currentDate]) {
    final now = currentDate ?? DateTime.now();
    final start = DateTime.parse(startDate);
    
    // If current date is before start date, no turns completed
    if (now.isBefore(start)) {
      return 0;
    }

    var completedTurns = 0;

    switch (frequency) {
      case Frequency.daily:
        final difference = now.difference(start).inDays;
        completedTurns = difference;
      case Frequency.weekly:
        final difference = now.difference(start).inDays;
        completedTurns = (difference / 7).floor();
      case Frequency.monthly:
        final difference = now.difference(start).inDays;
        completedTurns = (difference / 30.44).floor(); // Average days per month
      case Frequency.quarterly:
        final difference = now.difference(start).inDays;
        completedTurns = (difference / 91.25).floor(); // Average days per quarter
      case Frequency.halfYearly:
        final difference = now.difference(start).inDays;
        completedTurns = (difference / 182.5).floor(); // Average days per 6 months
      case Frequency.yearly:
        final difference = now.difference(start).inDays;
        completedTurns = (difference / 365.25).floor(); // Average days per year
      case Frequency.none:
        completedTurns = 0;
    }

    // Ensure we don't exceed the total number of turns if specified
    if (maxRecurrencies > 0 && maxRecurrencies != 999) {
      completedTurns = completedTurns.clamp(0, maxRecurrencies);
    }

    return completedTurns;
  }

  /// Calculates the number of remaining turns
  int getRemainingTurns([DateTime? currentDate]) {
    if (maxRecurrencies <= 0 || maxRecurrencies == 999) {
      return -1; // Unlimited or invalid
    }
    
    final completed = getCompletedTurns(currentDate);
    return (maxRecurrencies - completed).clamp(0, maxRecurrencies);
  }

  /// Calculates the progress percentage (0.0 to 1.0)
  double getProgressPercentage([DateTime? currentDate]) {
    if (maxRecurrencies <= 0 || maxRecurrencies == 999) {
      return 0; // No progress for unlimited donations
    }
    
    final completed = getCompletedTurns(currentDate);
    return (completed / maxRecurrencies).clamp(0.0, 1.0);
  }

  /// Checks if the recurring donation is completed
  bool get isCompleted {
    if (maxRecurrencies <= 0 || maxRecurrencies == 999) {
      return false; // Unlimited donations are never completed
    }
    
    return getCompletedTurns() >= maxRecurrencies;
  }

  /// Gets a summary of the donation status for analytics and debugging
  Map<String, dynamic> getStatusSummary([DateTime? currentDate]) {
    final completed = getCompletedTurns(currentDate);
    final remaining = getRemainingTurns(currentDate);
    final progress = getProgressPercentage(currentDate);
    
    return {
      'id': id,
      'current_state': currentState.name,
      'frequency': frequency.name,
      'start_date': startDate,
      'max_recurrencies': maxRecurrencies,
      'completed_turns': completed,
      'remaining_turns': remaining,
      'progress_percentage': progress,
      'is_completed': isCompleted,
      'is_unlimited': maxRecurrencies == 999,
    };
  }

  @override
  List<Object> get props => [
        id,
        userId,
        amount,
        frequency,
        maxRecurrencies,
        startDate,
        endDate ?? '',
        currentState,
        creationDateTime,
        collectGroupName,
        transactions,
        collectGroup,
      ];
}
