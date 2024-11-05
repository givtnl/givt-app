import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/edit_child/repositories/edit_child_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class SetupBedtimeCubit extends CommonCubit<dynamic, dynamic> {
  SetupBedtimeCubit(this._editChildRepository)
      : super(const BaseState.initial());

  final EditChildRepository _editChildRepository;

  void onClickContinue(String guid, DateTime bedtime, int winddownMinutes) {
    try {
      _editChildRepository.editChildBedtime(guid, bedtime, winddownMinutes);
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
      //TODO
    }
  }
}
