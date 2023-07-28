import 'package:equatable/equatable.dart';
import 'package:givt_app/shared/models/collect_group.dart';

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
