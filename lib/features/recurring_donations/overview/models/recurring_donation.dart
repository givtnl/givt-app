import 'package:equatable/equatable.dart';
import 'package:jiffy/jiffy.dart';

enum RecurringDonationState {
  cancelled,
  active,
  finished,
  stopped;

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
    required this.numberOfTurns,
    required this.startDate,
    this.endDate,
    required this.currentState,
    required this.creationDateTime,
    required this.collectGroupName,
    this.transactions = const [],
    this.nextRecurringDonation,
    this.currentTurn = 0,
  });

  factory RecurringDonation.fromJson(Map<String, dynamic> json) =>
      RecurringDonation(
        id: json['id'] as String,
        userId: json['userId'] as String,
        amount: (json['amount'] as num).toDouble(),
        frequency: Frequency.fromString(json['frequency'] as String),
        numberOfTurns: json['numberOfTurns'] as int,
        startDate: json['startDate'] as String,
        endDate: json['endDate'] as String?,
        currentState: RecurringDonationState.fromJson(json),
        creationDateTime: json['creationDateTime'] as String,
        collectGroupName: json['collectGroupName'] as String,
        transactions:
            (json['transactions'] as List<dynamic>?)
                ?.map(
                  (e) => RecurringDonationTransaction.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList() ??
            [],
        nextRecurringDonation: json['nextRecurringDonation'] as String?,
        currentTurn: (json['currentTurn'] as num?)?.toInt() ?? 0,
      );

  final String id;
  final String userId;
  final double amount;
  final Frequency frequency;
  final int numberOfTurns;
  final String startDate;
  final String? endDate;
  final RecurringDonationState currentState;
  final String creationDateTime;
  final String collectGroupName;
  final List<RecurringDonationTransaction> transactions;
  final String? nextRecurringDonation;
  final int currentTurn;

  // Legacy properties for backward compatibility
  num get amountPerTurn => amount;
  String get namespace => collectGroupName;
  int get endsAfterTurns => numberOfTurns;

  RecurringDonation copyWith({
    String? id,
    String? userId,
    double? amount,
    Frequency? frequency,
    int? numberOfTurns,
    String? startDate,
    String? endDate,
    RecurringDonationState? currentState,
    String? creationDateTime,
    String? collectGroupName,
    List<RecurringDonationTransaction>? transactions,
    String? nextRecurringDonation,
    int? currentTurn,
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
      numberOfTurns: numberOfTurns ?? endsAfterTurns ?? this.numberOfTurns,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentState: currentState ?? this.currentState,
      creationDateTime: creationDateTime ?? this.creationDateTime,
      collectGroupName: collectGroupName ?? namespace ?? this.collectGroupName,
      transactions: transactions ?? this.transactions,
      nextRecurringDonation:
          nextRecurringDonation ?? this.nextRecurringDonation,
      currentTurn: currentTurn ?? this.currentTurn,
    );
  }

  int get frequencyValue {
    return frequency.value;
  }

  /// Gets the next donation date from the API response
  DateTime? get nextDonationDate {
    if (nextRecurringDonation == null) return null;
    try {
      return DateTime.parse(nextRecurringDonation!);
    } catch (e) {
      return null;
    }
  }

  DateTime? get calculatedEndDate {
    if (endDate != null) {
      return DateTime.parse(endDate!);
    }
    return _evaluateEndDateFromRecurringDonation();
  }

  DateTime? _evaluateEndDateFromRecurringDonation() {
    if (numberOfTurns <= 0 || numberOfTurns == 999) {
      return null; // Unlimited or no end date
    }

    var startDateDateTime = DateTime.parse(startDate);
    final multiplier = numberOfTurns - 1;

    switch (frequency) {
      case Frequency.daily:
        startDateDateTime = startDateDateTime.add(Duration(days: multiplier));
      case Frequency.weekly:
        startDateDateTime = startDateDateTime.add(
          Duration(days: 7 * multiplier),
        );
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

  /// Calculates the number of remaining turns
  int getRemainingTurns() {
    if (numberOfTurns <= 0 || numberOfTurns == 999) {
      return -1; // Unlimited or invalid
    }

    final completed = currentTurn;
    return (numberOfTurns - completed).clamp(0, numberOfTurns);
  }

  /// Calculates the progress percentage (0.0 to 1.0)
  double getProgressPercentage() {
    if (numberOfTurns <= 0 || numberOfTurns == 999) {
      return 0; // No progress for unlimited donations
    }

    final completed = currentTurn;
    return (completed / numberOfTurns).clamp(0.0, 1.0);
  }

  /// Checks if the recurring donation is completed
  bool get isCompleted {
    if (numberOfTurns <= 0 || numberOfTurns == 999) {
      return false; // Unlimited donations are never completed
    }

    return currentTurn >= numberOfTurns;
  }

  /// Gets a summary of the donation status for analytics and debugging
  Map<String, dynamic> getStatusSummary() {
    final completed = currentTurn;
    final remaining = getRemainingTurns();
    final progress = getProgressPercentage();

    return {
      'id': id,
      'current_state': currentState.name,
      'frequency': frequency.name,
      'start_date': startDate,
      'max_recurrencies': numberOfTurns,
      'completed_turns': completed,
      'remaining_turns': remaining,
      'progress_percentage': progress,
      'is_completed': isCompleted,
      'is_unlimited': numberOfTurns == 999,
    };
  }

  @override
  List<Object> get props => [
    id,
    userId,
    amount,
    frequency,
    numberOfTurns,
    startDate,
    endDate ?? '',
    currentState,
    creationDateTime,
    collectGroupName,
    transactions,
    nextRecurringDonation ?? '',
    currentTurn,
  ];
}
