import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import '../app/generosity_hunt_repository.dart';

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
    return ScanUIModel(selectedLevel: _repository.selectedLevel);
  }

  @override
  Future<void> close() {
    _repository.removeListener(_emitData);
    return super.close();
  }
}
