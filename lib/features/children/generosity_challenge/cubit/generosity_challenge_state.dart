part of 'generosity_challenge_cubit.dart';

enum GenerosityChallengeStatus {
  initial,
  loading,
  overview,
  dayDetails,
  completed,
}

enum UnlockDayTimeDifference { minutes, days }

class GenerosityChallengeState extends Equatable {
  const GenerosityChallengeState({
    this.status = GenerosityChallengeStatus.initial,
    this.unlockDayTimeDifference = UnlockDayTimeDifference.days,
    this.activeDayIndex = -1,
    this.detailedDayIndex = -1,
    this.days = const [],
  });

  final List<Day> days;
  final int activeDayIndex;
  final int detailedDayIndex;
  final UnlockDayTimeDifference unlockDayTimeDifference;
  final GenerosityChallengeStatus status;

  bool get hasActiveDay => activeDayIndex != -1;

  bool get isLastCompleted =>
      days.lastIndexWhere((day) => day.isCompleted) == detailedDayIndex;

  GenerosityChallengeState copyWith({
    List<Day>? days,
    int? activeDayIndex,
    int? detailedDayIndex,
    GenerosityChallengeStatus? status,
    UnlockDayTimeDifference? unlockDayTimeDifference,
  }) {
    return GenerosityChallengeState(
      days: days ?? this.days,
      activeDayIndex: activeDayIndex ?? this.activeDayIndex,
      detailedDayIndex: detailedDayIndex ?? this.detailedDayIndex,
      status: status ?? this.status,
      unlockDayTimeDifference:
          unlockDayTimeDifference ?? this.unlockDayTimeDifference,
    );
  }

  @override
  List<Object> get props =>
      [days, activeDayIndex, detailedDayIndex, status, unlockDayTimeDifference];
}
