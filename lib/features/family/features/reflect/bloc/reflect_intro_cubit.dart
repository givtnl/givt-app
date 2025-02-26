import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/reflect_intro_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class ReflectIntroCubit extends CommonCubit<dynamic, ReflectIntroCustom> {
  ReflectIntroCubit(this._reflectAndShareRepository)
      : super(BaseState.data(_reflectAndShareRepository.isAIEnabled));

  final ReflectAndShareRepository _reflectAndShareRepository;

  late bool _isAIEnabled;

  void init() {
    _isAIEnabled = _reflectAndShareRepository.isAIEnabled;
    _emitData();
  }

  void _emitData() {
    emit(BaseState.data(_isAIEnabled));
  }

  void onAIEnabledChanged({required bool isEnabled}) {
    _isAIEnabled = isEnabled;
    _reflectAndShareRepository.isAIEnabled = isEnabled;
    _emitData();
  }
}
