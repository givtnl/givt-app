import 'package:givt_app/features/family/features/generosity_hunt/app/generosity_hunt_repository.dart';
import 'package:givt_app/features/family/features/generosity_hunt/cubit/level_select_cubit.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'scan_custom.dart';
part 'scan_uimodel.dart';

class ScanCubit extends CommonCubit<ScanUIModel, ScanCustom> {
  final GenerosityHuntRepository _repository;

  ScanCubit(this._repository) : super(const BaseState.loading()) {
    _repository.addListener(_emitData);
  }

  void init() {
    _emitData();
  }

  void _emitData() {
    emitData(_createUIModel());
  }

  ScanUIModel _createUIModel() {
    final selectedLevel = _repository.selectedLevel;
    final level = _repository.getLevelByNumber(selectedLevel);
    return ScanUIModel(selectedLevel: selectedLevel, level: level);
  }

  @override
  Future<void> close() {
    _repository.removeListener(_emitData);
    return super.close();
  }
}
