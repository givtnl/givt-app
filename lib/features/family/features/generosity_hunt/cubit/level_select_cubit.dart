import 'package:givt_app/features/family/features/generosity_hunt/app/generosity_hunt_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'level_select_custom.dart';
part 'level_select_uimodel.dart';

class LevelSelectCubit
    extends CommonCubit<LevelSelectUIModel, LevelSelectCustom> {
  LevelSelectCubit(this._repository) : super(const BaseState.initial()) {
    // Listen to repository changes and emit new data
    _repository.addListener(_onRepositoryChanged);
  }

  final GenerosityHuntRepository _repository;
  String? _currentProfileId;

  @override
  Future<void> close() {
    _repository.removeListener(_onRepositoryChanged);
    return super.close();
  }

  void _onRepositoryChanged() {
    if (_repository.levels == null) return;
    if (_repository.userState == null) return;

    // Emit new data whenever repository changes
    emitData(_createUIModel());
  }

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
  }

  LevelSelectUIModel _createUIModel() {
    final levels = (_repository.levels ?? [])
        .map((e) => LevelUIModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Update levels with unlock and completion status
    for (final level in levels) {
      level
        ..isUnlocked = _repository.isLevelUnlocked(level.level)
        ..isCompleted = _repository.isLevelCompleted(level.level);
    }

    return LevelSelectUIModel(
      selectedLevel: _repository.selectedLevel,
      levels: levels,
    );
  }
}
