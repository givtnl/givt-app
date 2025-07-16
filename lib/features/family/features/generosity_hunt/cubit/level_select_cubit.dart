import 'package:givt_app/features/family/features/generosity_hunt/app/generosity_hunt_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'level_select_custom.dart';
part 'level_select_uimodel.dart';

class LevelSelectCubit
    extends CommonCubit<LevelSelectUIModel, LevelSelectCustom> {
      
  LevelSelectCubit(this._repository) : super(const BaseState.initial()) {
    loadLevels();
  }

  final GenerosityHuntRepository _repository;

  void selectLevel(int level) {
    _repository.setLevel(level);
    emitCustom(NavigateToLevelIntroduction(level));
    // emitData(_createUIModel());
  }

  Future<void> loadLevels() async {
    await _repository.fetchLevels();
    emitData(_createUIModel());
  }

  LevelSelectUIModel _createUIModel() {
    final levels = (_repository.levels ?? [])
        .map((e) => LevelUIModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return LevelSelectUIModel(
      selectedLevel: _repository.selectedLevel,
      levels: levels,
    );
  }
}
