import 'package:givt_app/features/family/features/generosity_hunt/app/generosity_hunt_repository.dart';
import 'package:givt_app/features/family/features/generosity_hunt/cubit/level_select_cubit.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'generosity_hunt_level_intro_uimodel.dart';

class GenerosityHuntLevelIntroCubit
    extends CommonCubit<GenerosityHuntLevelIntroUIModel, void> {

  GenerosityHuntLevelIntroCubit(this._repository)
      : super(const BaseState.loading());
  final GenerosityHuntRepository _repository;

  void init() {
    emitData(_createUIModel());
  }

  GenerosityHuntLevelIntroUIModel _createUIModel() {
    final selectedLevel = _repository.selectedLevel;
    final level = _repository.getLevelByNumber(selectedLevel);
    
    return GenerosityHuntLevelIntroUIModel(
      selectedLevel: selectedLevel,
      level: level,
    );
  }
}
