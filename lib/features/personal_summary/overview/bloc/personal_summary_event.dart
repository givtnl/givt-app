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
