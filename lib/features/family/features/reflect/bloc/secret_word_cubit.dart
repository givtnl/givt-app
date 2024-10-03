import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class SecretWordCubit extends CommonCubit<String, dynamic> {
  SecretWordCubit(this._reflectAndShareRepository)
      : super(const BaseState.loading());

  final ReflectAndShareRepository _reflectAndShareRepository;

  void init() {
    emitData(_reflectAndShareRepository.getCurrentSecretWord());
  }

  GameProfile getSidekick() {
    return _reflectAndShareRepository.getCurrentSidekick();
  }

  void onShuffleClicked() {
    emitData(_reflectAndShareRepository.randomizeSecretWord());
  }

  void rolesClicked(List<GameProfile> profiles) {
    _reflectAndShareRepository.selectProfiles(profiles);
  }
}
