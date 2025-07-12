import 'package:givt_app/features/family/features/generosity_hunt/app/generosity_hunt_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'generosity_hunt_level_intro_uimodel.dart';

class GenerosityHuntLevelIntroCubit
    extends CommonCubit<GenerosityHuntLevelIntroUIModel, void> {
  final GenerosityHuntRepository _repository;

  GenerosityHuntLevelIntroCubit(this._repository)
      : super(const BaseState.loading());

  void init() {
    emitData(_createUIModel());
  }

  GenerosityHuntLevelIntroUIModel _createUIModel() {
    return GenerosityHuntLevelIntroUIModel(
      selectedLevel: _repository.selectedLevel,
    );
  }
}
