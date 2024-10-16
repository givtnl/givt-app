import 'package:givt_app/features/family/features/reflect/domain/models/summary_details.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class SummaryCubit extends CommonCubit<SummaryDetails, dynamic> {
  SummaryCubit(this._reflectAndShareRepository)
      : super(const BaseState.loading());

  final ReflectAndShareRepository _reflectAndShareRepository;

  void init() {
    final totalMinutesPlayed =
        (_reflectAndShareRepository.totalTimeSpentInSeconds / 60).ceil();
    final generousDeeds = _reflectAndShareRepository.getAmountOfGenerousDeeds();

    emitData(
      SummaryDetails(
        minutesPlayed: totalMinutesPlayed,
        generousDeeds: generousDeeds,
      ),
    );
  }

  void saveSummary() {
    _reflectAndShareRepository.saveSummaryStats();
  }
}
