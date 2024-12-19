import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/leave_game_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class LeaveGameCubit extends CommonCubit<dynamic, LeaveGameCustom> {
  LeaveGameCubit(this._reflectAndShareRepository)
      : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository;

  Future<void> onConfirmLeaveGameClicked() async {
    var kidsWithoutBedtimeSetup = <Profile>[];
    try {
      kidsWithoutBedtimeSetup =
          await _reflectAndShareRepository.getKidsWithoutBedtime();
    } catch (e) {
      // do nothing, as a fallback we just don't navigate to the bedtime screens
    }
    final isFirstRound = _reflectAndShareRepository.isFirstRound();
    final hasAtLeastStartedInterview =
        _reflectAndShareRepository.hasStartedInterview();
    final hasAnyGenerousPowerBeenSelected =
        _reflectAndShareRepository.hasAnyGenerousPowerBeenSelected();

    if (!isFirstRound && kidsWithoutBedtimeSetup.isNotEmpty) {
      emitCustom(
        LeaveGameCustom.introBedtime(kidsWithoutBedtimeSetup),
      );
    } else if ((isFirstRound && hasAtLeastStartedInterview) &&
        !hasAnyGenerousPowerBeenSelected) {
      emitCustom(
        const LeaveGameCustom.summary(),
      );
    } else if (hasAnyGenerousPowerBeenSelected) {
      emitCustom(
        const LeaveGameCustom.grateful(),
      );
    } else {
      emitCustom(
        const LeaveGameCustom.home(),
      );
    }
  }
}
