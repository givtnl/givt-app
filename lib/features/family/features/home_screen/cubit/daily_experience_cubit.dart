import 'dart:async';

import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/models/daily_experience_custom.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/models/daily_experience_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_stats.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class DailyExperienceCubit
    extends CommonCubit<DailyExperienceUIModel, DailyExperienceCustom> {
  DailyExperienceCubit(this._repo) : super(const BaseState.loading());

  final ReflectAndShareRepository _repo;

  late GameStats _gameStats;
  late DateTime midnight;

  StreamSubscription<GameStats>? _gameStatsSubscription;

  Future<void> init() async {
    final now = DateTime.now();
    midnight = DateTime(
      now.year,
      now.month,
      now.day + 1,
    );
    _gameStatsSubscription =
        _repo.onGameStatsUpdated.listen(_onGameStatsUpdated);
    try {
      _gameStats = await _repo.getGameStats();
    } catch (_) {
      //it's okay to fail, we'll stay updated via the stream
    }
    _emitData();
    emitCustom(DailyExperienceCustom.startCountdownTo(midnight));
  }

  void _onGameStatsUpdated(GameStats stats) {
    _gameStats = stats;
    _emitData();
  }

  void _emitData() {
    try {
      emit(
        BaseState.data(
          DailyExperienceUIModel(
            currentProgress: _gameStats.currentDailyXP!,
            total: _gameStats.dailyXPGoal!,
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
