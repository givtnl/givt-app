import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/stage_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class StageCubit extends CommonCubit<StageUIModel, dynamic> {
  StageCubit(this._reflectAndShareRepository)
      : super(
          BaseState.data(
            StageUIModel(
              isAITurnedOn: _reflectAndShareRepository.isAITurnedOn(),
              showAIFeatures: _reflectAndShareRepository.isAiAllowed(),
            ),
          ),
        );

  final ReflectAndShareRepository _reflectAndShareRepository;

  void init() {}

  void _emitData() {
    emit(
      BaseState.data(
        StageUIModel(
          isAITurnedOn: _reflectAndShareRepository.isAIEnabled,
          showAIFeatures: _reflectAndShareRepository.isAiAllowed(),
        ),
      ),
    );
  }

  void onAIEnabledChanged({required bool isEnabled}) {
    _reflectAndShareRepository.isAIEnabled = isEnabled;
    _emitData();
  }
}
