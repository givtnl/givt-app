import 'package:givt_app/features/family/features/barcode_hunt/app/barcode_hunt_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'barcode_hunt_level_intro_uimodel.dart';

class BarcodeHuntLevelIntroCubit
    extends CommonCubit<BarcodeHuntLevelIntroUIModel, void> {
  final BarcodeHuntRepository _repository;

  BarcodeHuntLevelIntroCubit(this._repository)
      : super(const BaseState.loading());

  void init() {
    emitData(_createUIModel());
  }

  BarcodeHuntLevelIntroUIModel _createUIModel() {
    return BarcodeHuntLevelIntroUIModel(
      selectedLevel: _repository.selectedLevel,
    );
  }
}
