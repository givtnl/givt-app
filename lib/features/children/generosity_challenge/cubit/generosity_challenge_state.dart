part of 'generosity_challenge_cubit.dart';

enum GenerosityChallengeStatus {
  initial,
  loading,
  overview,
  activeDay,
  completed,
}

class GenerosityChallengeState extends Equatable {
  const GenerosityChallengeState({
    this.status = GenerosityChallengeStatus.initial,
    this.activeDayIndex = -1,
    this.days = const [],
  });

  final List<Day> days;
  final int activeDayIndex;
  final GenerosityChallengeStatus status;

  GenerosityChallengeState copyWith({
    List<Day>? days,
    int? activeDayIndex,
    GenerosityChallengeStatus? status,
  }) {
    return GenerosityChallengeState(
      days: days ?? this.days,
      activeDayIndex: activeDayIndex ?? this.activeDayIndex,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [days, activeDayIndex, status];
}
