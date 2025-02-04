import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/experience_stats.dart';
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
  bool _tagsWereSelected = false;
  String _audioPath = '';
  List<Profile> _players = const [];
  ExperienceStats? _experienceStats;

  Future<void> init() async {
    await saveSummary();
    _totalMinutesPlayed =
        (_reflectAndShareRepository.totalTimeSpentInSeconds / 60).ceil();
    _generousDeeds = _reflectAndShareRepository.getAmountOfGenerousDeeds();
    _tagsWereSelected =
        _reflectAndShareRepository.hasAnyGenerousPowerBeenSelected();
    await getPlayerProfiles();
    _emitData();
  }

  Future<void> getPlayerProfiles() async {
    _players = await _reflectAndShareRepository.getPlayerProfiles();
    _emitData();
  }

  void audioAvailable(String path) {
    _audioPath = path;
    _emitData();
  }

  Future<void> shareAudio(String path) async {
    await _reflectAndShareRepository.shareAudio(path);
    _audioPath = '';
  }

  Future<void> saveSummary() async {
    _experienceStats = await _reflectAndShareRepository.saveSummaryStats();
  }

  void onCloseGame() {
    _reflectAndShareRepository.onCloseGame();
  }

  void onDeleteAudio() {
    _audioPath = '';
    _emitData();
  }

  void _emitData() {
    emitData(
      SummaryDetails(
        minutesPlayed: _totalMinutesPlayed,
        generousDeeds: _generousDeeds,
        players: _players,
        tagsWereSelected: _tagsWereSelected,
        audioPath: _audioPath,
        xpEarnedForTime: _experienceStats?.xpEarnedForTime,
        xpEarnedForDeeds: _experienceStats?.xpEarnedForDeeds,
      ),
    );
  }
}
