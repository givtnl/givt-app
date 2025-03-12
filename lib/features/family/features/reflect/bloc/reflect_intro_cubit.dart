import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/reflect_intro_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class ReflectIntroCubit extends CommonCubit<dynamic, ReflectIntroCustom> {
  ReflectIntroCubit(this._reflectAndShareRepository)
      : super(BaseState.data(_reflectAndShareRepository.isAITurnedOn()));

  final ReflectAndShareRepository _reflectAndShareRepository;

  void init() {
    _emitData();
  }

  void _emitData() {
    emit(BaseState.data(_reflectAndShareRepository.isAITurnedOn()));
  }
  
  void _goToStageScreen() {
    emitCustom(const ReflectIntroCustom.goToStageScreen());
  }

  void onStartClicked() {
    _goToStageScreen();
  }
}
