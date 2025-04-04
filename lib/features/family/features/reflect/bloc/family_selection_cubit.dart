import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/game_roles_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:volume_controller/volume_controller.dart';

class FamilySelectionCubit
    extends CommonCubit<List<GameProfile>, GameRolesCustom> {
  FamilySelectionCubit(this._reflectAndShareRepository)
      : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository;
  final VolumeController _volumeController = VolumeController.instance;
  GameProfile? _superhero;

  void init() {
    emit(const BaseState.loading());
    _reflectAndShareRepository
      ..emptyAllProfiles()
      ..getFamilyProfiles().then((profiles) {
        emit(BaseState.data(profiles));
      });
  }

  Future<void> rolesClicked(List<GameProfile> profiles) async {
    _reflectAndShareRepository
      ..selectProfiles(profiles)
      ..randomlyAssignRoles();
    _superhero = _reflectAndShareRepository.getCurrentSuperhero();

    final volume = await _volumeController.getVolume();
    if (volume < 0.1) {
      emitCustom(const ShowVolumeBottomsheet());
      return;
    }
    navigate();
  }

  void navigate() {
    _superhero ??= _reflectAndShareRepository.getCurrentSuperhero();
    if (isFirstRound()) {
      emitCustom(GoToPassThePhone(profile: _superhero!));
    } else {
      emitCustom(GoToPassThePhoneAndReplace(profile: _superhero!));
    }
  }

  bool isFirstRound() {
    return _reflectAndShareRepository.isFirstRound();
  }
}
