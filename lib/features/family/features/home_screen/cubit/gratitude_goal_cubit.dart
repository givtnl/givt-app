import 'dart:async';

import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/models/gratitude_goal_custom.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/models/gratitude_goal_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_stats.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class GratitudeGoalCubit
    extends CommonCubit<GratitudeGoalUIModel, GratitudeGoalCustom> {
  GratitudeGoalCubit(this._repo) : super(const BaseState.loading());

  final ReflectAndShareRepository _repo;

  late GameStats _gameStats;
  late DateTime endOfWeek;

  StreamSubscription<GameStats>? _gameStatsSubscription;

  Future<void> init() async {
    final now = DateTime.now();
    final adjustedWeekday = now.weekday;
    final daysUntilSunday = now.weekday == 7 ? 0 : (DateTime.sunday - adjustedWeekday);
    endOfWeek = DateTime(
      now.year,
      now.month,
      now.day + daysUntilSunday,
      23,
      59,
      59,
    );

    _gameStatsSubscription =
        _repo.onGameStatsUpdated.listen(_onGameStatsUpdated);
    try {
      _gameStats = await _repo.getGameStats();
    } catch (_) {
      //it's okay to fail, we'll stay updated via the stream
    }
    _emitData();
    emitCustom(GratitudeGoalCustom.startCountdownTo(endOfWeek));
  }

  void _onGameStatsUpdated(GameStats stats) {
    _gameStats = stats;
    _emitData();
  }

  void _emitData() {
    try {
      emit(
        BaseState.data(
          GratitudeGoalUIModel(
            gratitudeGoal: _gameStats.gratitudeGoal,
            gratitudeGoalCurrent: _gameStats.gratitudeGoalCurrent,
          ),
        ),
      );
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
      emitError(e.toString());
    }
  }

  @override
  Future<void> close() {
    _gameStatsSubscription?.cancel();
    return super.close();
  }
}
