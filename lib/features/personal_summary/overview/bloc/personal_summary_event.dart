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
    required this.frequency,
  });
  final int amount;
  final GivingGoalFrequency frequency;

  @override
  List<Object> get props => [amount, frequency];
}

class PersonalSummaryGoalRemove extends PersonalSummaryEvent {
  const PersonalSummaryGoalRemove();
}

class PersonalSummaryGoalAdd extends PersonalSummaryEvent {
  const PersonalSummaryGoalAdd({
    required this.amount,
    required this.frequency,
  });
  final int amount;
  final GivingGoalFrequency frequency;

  @override
  List<Object> get props => [amount, frequency];
}
