import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class FamilySelectionCubit extends CommonCubit<List<GameProfile>, GameProfile> {
  FamilySelectionCubit(this._reflectAndShareRepository)
      : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository;

  void init() {
    emit(const BaseState.loading());
    _reflectAndShareRepository
      ..emptyAllProfiles()
      ..getFamilyProfiles().then((profiles) {
        emit(BaseState.data(profiles));
      });
  }

  void rolesClicked(List<GameProfile> profiles) {
    _reflectAndShareRepository
      ..selectProfiles(profiles)
      ..randomlyAssignRoles();

    emitCustom(_reflectAndShareRepository.getCurrentSuperhero());
  }

  bool isFirstRound() {
    return _reflectAndShareRepository.isFirstRound();
  }
}
