import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/edit_child/repositories/edit_child_repository.dart';
import 'package:givt_app/features/family/features/bedtime/presentation/models/bedtime.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class SetupBedtimeCubit extends CommonCubit<dynamic, Bedtime> {
  SetupBedtimeCubit(this._editChildRepository)
      : super(const BaseState.initial());

  final EditChildRepository _editChildRepository;
  String _bedtimeSliderValueToUtc(double amount) {
    final hours = getMilitaryTimeHour(amount.floor());
    final minutes = ((amount - amount.floor()) * 60).toInt();
    final bedtime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hours,
      minutes,
    ).toUtc();

    return '${bedtime.hour.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  int getMilitaryTimeHour(int amount) {
    if (amount < 6 || amount > 9) {
      throw ArgumentError('Bedtime must be between 6 PM and 9 PM');
    }
    switch (amount) {
      case 6:
        return 18;
      case 7:
        return 19;
      case 8:
        return 20;
      case 9:
        return 21;
      default:
        return 19;
    }
  }

  void onClickContinue(
      String guid, double bedtimeSliderValue, int windDownValue) {
    final bedtime = Bedtime(
      id: guid,
      bedtimeInUtc: _bedtimeSliderValueToUtc(bedtimeSliderValue),
      winddownMinutes: windDownValue,
    );
    try {
      _editChildRepository.editChildBedtime(bedtime);
      emitCustom(bedtime);
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
      emitError(e.toString());
    }
  }
}
