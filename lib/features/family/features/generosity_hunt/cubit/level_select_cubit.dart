import 'package:givt_app/features/family/features/generosity_hunt/app/generosity_hunt_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'level_select_custom.dart';
part 'level_select_uimodel.dart';

class LevelSelectCubit
    extends CommonCubit<LevelSelectUIModel, LevelSelectCustom> {
  LevelSelectCubit(this._repository) : super(const BaseState.initial());

  final GenerosityHuntRepository _repository;
  String? _currentProfileId;

  void init(String currentProfileId) {
    _currentProfileId = currentProfileId;
    loadLevels();
  }

  Future<void> selectLevel(int level) async {
    _repository.setLevel(level);

    // Create a game when a level is selected
    try {
      await _repository.createGame(_currentProfileId!);
      emitCustom(NavigateToLevelIntroduction(level));
    } catch (e) {
      // Handle error - for now just rethrow, but could emit error state
      rethrow;
    }
  }

  Future<void> loadLevels() async {
    await _repository.fetchLevels();
    await _repository.fetchUserState(_currentProfileId!);
    emitData(_createUIModel());
  }

  LevelSelectUIModel _createUIModel() {
    final levels = (_repository.levels ?? [])
        .map((e) => LevelUIModel.fromJson(e as Map<String, dynamic>))
        .toList();
    
    // Update levels with unlock and completion status
    for (final level in levels) {
      level.isUnlocked = _repository.isLevelUnlocked(level.level);
      level.isCompleted = _repository.isLevelCompleted(level.level);
    }
    
    return LevelSelectUIModel(
      selectedLevel: _repository.selectedLevel,
      levels: levels,
    );
  }
}
