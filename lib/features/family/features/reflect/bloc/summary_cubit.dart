import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/summary_details.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class SummaryCubit extends CommonCubit<SummaryDetails, dynamic> {
  SummaryCubit(this._reflectAndShareRepository)
      : super(const BaseState.loading());

  final ReflectAndShareRepository _reflectAndShareRepository;
  int _totalMinutesPlayed = 0;
  int _generousDeeds = 0;
  List<Profile> _missingAdults = const [];

  void init() {
    saveSummary();
    _totalMinutesPlayed =
        (_reflectAndShareRepository.totalTimeSpentInSeconds / 60).ceil();
    _generousDeeds = _reflectAndShareRepository.getAmountOfGenerousDeeds();
    checkAllParentsPlayed();
    emitData(
      SummaryDetails(
        minutesPlayed: _totalMinutesPlayed,
        generousDeeds: _generousDeeds,
      ),
    );
  }

  Future<void> checkAllParentsPlayed() async {
    _missingAdults = await _reflectAndShareRepository.missingAdults();

    emitData(
      SummaryDetails(
        minutesPlayed: _totalMinutesPlayed,
        generousDeeds: _generousDeeds,
        missingAdults: _missingAdults,
      ),
    );
  }

  void audioAvailable(String path) {
    emitData(
      SummaryDetails(
        minutesPlayed: _totalMinutesPlayed,
        generousDeeds: _generousDeeds,
        missingAdults: _missingAdults,
        audioPath: path,
      ),
    );
  }

  Future<void> shareAudio(String path) async {
    await _reflectAndShareRepository.shareAudio(path);
  }

  void saveSummary() {
    _reflectAndShareRepository.saveSummaryStats();
  }

  void onCloseGame() {
    _reflectAndShareRepository.onCloseGame();
  }

  void onDeleteAudio() {
    emitData(
      SummaryDetails(
        minutesPlayed: _totalMinutesPlayed,
        generousDeeds: _generousDeeds,
        missingAdults: _missingAdults,
        audioPath: '',
      ),
    );
  }
}
