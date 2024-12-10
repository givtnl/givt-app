import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/leave_game_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class LeaveGameCubit extends CommonCubit<dynamic, LeaveGameCustom> {
  LeaveGameCubit(this._reflectAndShareRepository)
      : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository;

  void onConfirmLeaveGameClicked() {
    emitCustom(
      LeaveGameCustom(
        isFirstRound: _reflectAndShareRepository.isFirstRound(),
        hasAtLeastStartedInterview:
            _reflectAndShareRepository.hasStartedInterview(),
      ),
    );
  }
}
