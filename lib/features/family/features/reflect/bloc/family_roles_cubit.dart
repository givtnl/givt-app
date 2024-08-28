import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class FamilyRolesCubit extends CommonCubit<List<GameProfile>, dynamic> {
  FamilyRolesCubit(this._reflectAndShareRepository)
      : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository;

  void init() {
    final list = _reflectAndShareRepository.getPlayers();
    emit(const BaseState.loading());
    _reflectAndShareRepository.getFamilyProfiles().then((profiles) {
      emit(BaseState.data(profiles));
    });
  }
}
