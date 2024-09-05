import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class GuessSecretWordCubit extends CommonCubit<String, dynamic> {
  GuessSecretWordCubit(this._reflectAndShareRepository)
      : super(const BaseState.loading());

  final ReflectAndShareRepository _reflectAndShareRepository;

  void init() {
    emitData(_reflectAndShareRepository.getCurrentSecretWord());
  }
}
