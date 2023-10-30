part of 'personal_summary_bloc.dart';

abstract class PersonalSummaryEvent extends Equatable {
  const PersonalSummaryEvent();

  @override
  List<Object> get props => [];
}

class PersonalSummaryInit extends PersonalSummaryEvent {
  const PersonalSummaryInit();
}

class PersonalSummaryMonthChange extends PersonalSummaryEvent {
  const PersonalSummaryMonthChange({
    required this.increase,
  });
  final bool increase;

  @override
  List<Object> get props => [increase];
}

class PersonalSummaryGoalChange extends PersonalSummaryEvent {
  const PersonalSummaryGoalChange({
    required this.amount,
    required this.periodicity,
  });
  final int amount;
  final int periodicity;

  @override
  List<Object> get props => [amount, periodicity];
}

class PersonalSummaryGoalRemove extends PersonalSummaryEvent {
  const PersonalSummaryGoalRemove();
}

class PersonalSummaryGoalAdd extends PersonalSummaryEvent {
  const PersonalSummaryGoalAdd({
    required this.amount,
    required this.periodicity,
  });
  final int amount;
  final int periodicity;

  @override
  List<Object> get props => [amount, periodicity];
}
