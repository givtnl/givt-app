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

class RecurringDonation extends Equatable {
  const RecurringDonation({
    required this.amountPerTurn,
    required this.cronExpression,
    required this.currentState,
    required this.id,
    required this.endsAfterTurns,
    required this.namespace,
    required this.startDate,
    this.collectGroup = const CollectGroup.empty(),
  });

  factory RecurringDonation.fromJson(Map<String, dynamic> json) =>
      RecurringDonation(
        amountPerTurn: json['amountPerTurn'] as num,
        cronExpression: json['cronExpression'] as String,
        currentState: RecurringDonationState.fromJson(json),
        id: json['id'] as String,
        endsAfterTurns: json['endsAfterTurns'] as int,
        namespace: json['namespace'] as String,
        startDate: json['startDate'] as String,
      );

  final num amountPerTurn;
  final String cronExpression;
  final RecurringDonationState currentState;
  final String id;
  final int endsAfterTurns;
  final String namespace;
  final String startDate;
  final CollectGroup collectGroup;

  RecurringDonation copyWith({
    num? amountPerTurn,
    String? cronExpression,
    RecurringDonationState? currentState,
    String? id,
    int? endsAfterTurns,
    String? namespace,
    String? startDate,
    CollectGroup? collectGroup,
  }) {
    return RecurringDonation(
      amountPerTurn: amountPerTurn ?? this.amountPerTurn,
      cronExpression: cronExpression ?? this.cronExpression,
      currentState: currentState ?? this.currentState,
      id: id ?? this.id,
      endsAfterTurns: endsAfterTurns ?? this.endsAfterTurns,
      namespace: namespace ?? this.namespace,
      startDate: startDate ?? this.startDate,
      collectGroup: collectGroup ?? this.collectGroup,
    );
  }

  int get frequency {
    return _evaluateFrequencyFromCronExpression();
  }

  DateTime get endDate {
    return _evaluateEndDateFromRecurringDonation();
  }

  int _evaluateFrequencyFromCronExpression() {
    final elements = cronExpression.split(' ');
    final day = elements[2];
    final month = elements[3];
    var frequency = 0;
    if (day != '*') {
      frequency = month == '*'
          ? 1
          : month.contains('/3')
              ? 2
              : month.contains('/6')
                  ? 3
                  : 4;
    }
    return frequency;
  }

  DateTime _evaluateEndDateFromRecurringDonation() {
    var startDateDateTime = DateTime.parse(startDate);
    final multiplier = endsAfterTurns - 1;
    final frequency = _evaluateFrequencyFromCronExpression();
    switch (frequency) {
      case 0:
        startDateDateTime = startDateDateTime.copyWith(
          day: startDateDateTime.day + (7 * multiplier),
        );
      case 1:
        startDateDateTime = startDateDateTime.copyWith(
          month: startDateDateTime.month + multiplier,
        );
      case 2:
        startDateDateTime = startDateDateTime.copyWith(
          month: startDateDateTime.month + (3 * multiplier),
        );
      case 3:
        startDateDateTime = startDateDateTime.copyWith(
          month: startDateDateTime.month + (6 * multiplier),
        );
      case 4:
        startDateDateTime = startDateDateTime.copyWith(
          year: startDateDateTime.year + multiplier,
        );
    }
    return startDateDateTime;
  }

  DateTime getNextDonationDate(DateTime previousDate) {
    final frequency = _evaluateFrequencyFromCronExpression();
    final jiffy = Jiffy.parseFromDateTime(previousDate);

    DateTime nextDonationDate;

    switch (frequency) {
      case 0:
        nextDonationDate = jiffy.add(days: 7).dateTime;
      case 1:
        nextDonationDate = jiffy.add(months: 1).dateTime;
      case 2:
        nextDonationDate = jiffy.add(months: 3).dateTime;
      case 3:
        nextDonationDate = jiffy.add(months: 6).dateTime;
      case 4:
        nextDonationDate = jiffy.add(years: 1).dateTime;
      default:
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
    final frequency = _evaluateFrequencyFromCronExpression();
    
    // Calculate the date of the next turn based on start date and completed turns
    DateTime nextDate = start;
    
    switch (frequency) {
      case 0: // Weekly
        nextDate = start.add(Duration(days: 7 * (completedTurns + 1)));
        break;
      case 1: // Monthly
        nextDate = start.copyWith(month: start.month + completedTurns + 1);
        break;
      case 2: // Quarterly
        nextDate = start.copyWith(month: start.month + (3 * (completedTurns + 1)));
        break;
      case 3: // Semi-annually
        nextDate = start.copyWith(month: start.month + (6 * (completedTurns + 1)));
        break;
      case 4: // Annually
        nextDate = start.copyWith(year: start.year + completedTurns + 1);
        break;
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

    final frequency = _evaluateFrequencyFromCronExpression();
    int completedTurns = 0;

    switch (frequency) {
      case 0: // Weekly
        final difference = now.difference(start).inDays;
        completedTurns = (difference / 7).floor();
        break;
      case 1: // Monthly
        final difference = now.difference(start).inDays;
        completedTurns = (difference / 30.44).floor(); // Average days per month
        break;
      case 2: // Quarterly
        final difference = now.difference(start).inDays;
        completedTurns = (difference / 91.25).floor(); // Average days per quarter
        break;
      case 3: // Semi-annually
        final difference = now.difference(start).inDays;
        completedTurns = (difference / 182.5).floor(); // Average days per 6 months
        break;
      case 4: // Annually
        final difference = now.difference(start).inDays;
        completedTurns = (difference / 365.25).floor(); // Average days per year
        break;
      default:
        completedTurns = 0;
    }

    // Ensure we don't exceed the total number of turns if specified
    if (endsAfterTurns > 0 && endsAfterTurns != 999) {
      completedTurns = completedTurns.clamp(0, endsAfterTurns);
    }

    return completedTurns;
  }

  /// Calculates the number of remaining turns
  int getRemainingTurns([DateTime? currentDate]) {
    if (endsAfterTurns <= 0 || endsAfterTurns == 999) {
      return -1; // Unlimited or invalid
    }
    
    final completed = getCompletedTurns(currentDate);
    return (endsAfterTurns - completed).clamp(0, endsAfterTurns);
  }

  /// Calculates the progress percentage (0.0 to 1.0)
  double getProgressPercentage([DateTime? currentDate]) {
    if (endsAfterTurns <= 0 || endsAfterTurns == 999) {
      return 0.0; // No progress for unlimited donations
    }
    
    final completed = getCompletedTurns(currentDate);
    return (completed / endsAfterTurns).clamp(0.0, 1.0);
  }

  /// Checks if the recurring donation is completed
  bool get isCompleted {
    if (endsAfterTurns <= 0 || endsAfterTurns == 999) {
      return false; // Unlimited donations are never completed
    }
    
    return getCompletedTurns() >= endsAfterTurns;
  }

  /// Gets a summary of the donation status for analytics and debugging
  Map<String, dynamic> getStatusSummary([DateTime? currentDate]) {
    final completed = getCompletedTurns(currentDate);
    final remaining = getRemainingTurns(currentDate);
    final progress = getProgressPercentage(currentDate);
    
    return {
      'id': id,
      'current_state': currentState.name,
      'frequency': frequency,
      'start_date': startDate,
      'ends_after_turns': endsAfterTurns,
      'completed_turns': completed,
      'remaining_turns': remaining,
      'progress_percentage': progress,
      'is_completed': isCompleted,
      'is_unlimited': endsAfterTurns == 999,
    };
  }

  @override
  List<Object> get props => [
        amountPerTurn,
        cronExpression,
        currentState,
        id,
        endsAfterTurns,
        namespace,
        startDate,
        collectGroup,
        frequency,
        endDate,
      ];
}
