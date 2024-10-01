import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class ResultCubit extends CommonCubit<String, dynamic> {
  ResultCubit(this._reflectAndShareRepository)
      : super(const BaseState.loading());

  final ReflectAndShareRepository _reflectAndShareRepository;

  void init() {
    emitData(_reflectAndShareRepository.getCurrentSecretWord());
  }

  void finishGame() {
    _reflectAndShareRepository.emptyAllProfiles();
  }

  /// Checks if the game is finished.
  ///
  /// Returns `true` when all family members have gone as superheroes,
  /// otherwise returns `false` indicating that a new round can start.
  bool isGameFinished() {
    return _reflectAndShareRepository.isGameFinished();
  }
}
