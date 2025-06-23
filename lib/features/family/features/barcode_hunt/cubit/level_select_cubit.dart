import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import '../app/barcode_hunt_repository.dart';

part 'level_select_custom.dart';
part 'level_select_uimodel.dart';

class LevelSelectCubit
    extends CommonCubit<LevelSelectUIModel, LevelSelectCustom> {
      
  LevelSelectCubit(this._repository) : super(const BaseState.initial());

  final BarcodeHuntRepository _repository;

  void selectLevel(int level) {
    _repository.setLevel(level);
    emitCustom(NavigateToLevelIntroduction(level));
    emitData(_createUIModel());
  }

  void init() {
    emitData(_createUIModel());
  }

  LevelSelectUIModel _createUIModel() {
    return LevelSelectUIModel(selectedLevel: _repository.selectedLevel);
  }
}
