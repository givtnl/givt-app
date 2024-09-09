import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
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

  // Just temporary to fetch a superhero.
  // Needs to be replaced with the actual logic with KIDS-1344.
  GameProfile getNextSuperhero() {
    return _reflectAndShareRepository.getCurrentSuperhero();
  }
}
