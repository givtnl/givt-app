import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class FamilyRolesCubit extends CommonCubit<List<GameProfile>, GameProfile> {
  FamilyRolesCubit(this._reflectAndShareRepository)
      : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository;

  void init() {
    List<GameProfile> list;
    
    if (_reflectAndShareRepository.isFirstRound()) {
      list = _reflectAndShareRepository.randomlyAssignRoles();
    } else {
      list = _reflectAndShareRepository.assignRolesForNextRound();
    }

    emitData(list);
  }

  void onClickStart() {
    emitCustom(_reflectAndShareRepository.getCurrentSuperhero());
  }

  bool isFirstRound() {
    return _reflectAndShareRepository.isFirstRound();
  }
}
