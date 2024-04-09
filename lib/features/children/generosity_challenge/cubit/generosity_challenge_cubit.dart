import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/generosity_challenge/models/day.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';

part 'generosity_challenge_state.dart';

class GenerosityChallengeCubit extends Cubit<GenerosityChallengeState> {
  GenerosityChallengeCubit(
    this._generosityChallengeRepository,
  ) : super(const GenerosityChallengeState());

  final GenerosityChallengeRepository _generosityChallengeRepository;

  Future<void> loadFromCache() async {
    emit(state.copyWith(status: GenerosityChallengeStatus.loading));

    final days = await _generosityChallengeRepository.loadFromCache();
    _refreshState(days);
  }

  void overview() =>
      emit(state.copyWith(status: GenerosityChallengeStatus.overview));

  void activeDay() =>
      emit(state.copyWith(status: GenerosityChallengeStatus.activeDay));

  Future<void> completeActiveDay() async {
    emit(state.copyWith(status: GenerosityChallengeStatus.loading));

    state.days[state.activeDayIndex] =
        Day(dateCompleted: DateTime.now().toIso8601String());

    await _generosityChallengeRepository.saveToCache(state.days);

    _refreshState(state.days);
  }

  int _findActiveDayIndex(List<Day> days) {
    final lastCompletedDayIndex = days.lastIndexWhere((day) => day.isCompleted);

    if (lastCompletedDayIndex > -1) {
      final nextActiveDayIndex = lastCompletedDayIndex + 1;
      if (nextActiveDayIndex <
          GenerosityChallengeHelper.generosityChallengeDays) {
        final lastCompletedDateTime =
            DateTime.parse(days[lastCompletedDayIndex].dateCompleted);
        final diff = lastCompletedDateTime.difference(DateTime.now());
        if (diff.inDays != 0) {
          return nextActiveDayIndex;
        } else {
          //no active day yet
          return -1;
        }
      } else {
        //the challenge is completed, no active day
        return -1;
      }
    } else {
      //first day of the challenge
      return 0;
    }
  }

  bool _isChallengeCompleted(List<Day> days) {
    return days.indexWhere((day) => !day.isCompleted) == -1;
  }

  void _refreshState(List<Day> days) {
    final activeDayIndex = _findActiveDayIndex(days);
    final isChallengeCompleted = _isChallengeCompleted(days);

    emit(
      state.copyWith(
        days: days,
        activeDayIndex: activeDayIndex,
        status: isChallengeCompleted
            ? GenerosityChallengeStatus.completed
            : GenerosityChallengeStatus.overview,
      ),
    );
  }
}
