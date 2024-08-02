import 'package:equatable/equatable.dart';

class RecurringDonation extends Equatable {
  const RecurringDonation({
    required this.userId,
    required this.frequency,
    required this.startDate,
    required this.amountPerTurn,
    required this.namespace,
    required this.endsAfterTurns,
    required this.country,
  });

  final String userId;
  final int frequency;
  final DateTime startDate;
  final num amountPerTurn;
  final String namespace;
  final int endsAfterTurns;
  final String country;

  String get cronExpression {
    return _createCronExpressionByFrequency();
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'cronExpression': cronExpression,
      'startDate': startDate.toIso8601String(),
      'amountPerTurn': amountPerTurn,
      'namespace': namespace,
      'endsAfterTurns': endsAfterTurns,
      'country': country,
    };
  }

  String _createCronExpressionByFrequency() {
    switch (frequency) {
      case 0: //Week
        return '0 0 * * ${_getDayOfWeek(startDate.weekday)}';
      case 1: //Monthly
        return '0 0 ${startDate.day} * *';
      case 2: // 3 monthly
        return '0 0 ${startDate.day} ${_getQuarterlyCronFirstPart(startDate.month)}/3 *';
      case 3: // 6 monthly
        return '0 0 ${startDate.day} ${_getHalfYearlyCronFirstPart(startDate.month)}/6 *';
      case 4: // yearly
        return '0 0 ${startDate.day} ${startDate.month} *';
      default:
        return '';
    }
  }

  int _getQuarterlyCronFirstPart(int month) {
    switch (month) {
      case 0:
      case 3:
      case 6:
      case 9:
        return 1;
      case 1:
      case 4:
      case 7:
      case 10:
        return 2;
      case 2:
      case 5:
      case 8:
      case 11:
        return 3;
      default:
        return 0;
    }
  }

  int _getHalfYearlyCronFirstPart(int month) {
    if (month < 7) {
      return month + 1;
    } else {
      return month - 5;
    }
  }

  String _getDayOfWeek(int dayOfWeek) {
    switch (dayOfWeek) {
      case DateTime.monday:
        return 'MON';
      case DateTime.tuesday:
        return 'TUE';
      case DateTime.wednesday:
        return 'WED';
      case DateTime.thursday:
        return 'THU';
      case DateTime.friday:
        return 'FRI';
      case DateTime.saturday:
        return 'SAT';
      case DateTime.sunday:
        return 'SUN';
      default:
        return 'MON';
    }
  }

  @override
  List<Object> get props => [
        userId,
        frequency,
        startDate,
        amountPerTurn,
        namespace,
        endsAfterTurns,
        country,
      ];
}
