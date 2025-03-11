import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/experience_stats.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/summary_details.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/summary_details_custom.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/models/fun_dialog_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:in_app_review/in_app_review.dart';

class SummaryCubit extends CommonCubit<SummaryDetails, SummaryDetailsCustom> {
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
    emitLoading();
    try {
      await saveSummary();
      _totalMinutesPlayed =
          (_reflectAndShareRepository.totalTimeSpentInSeconds / 60).ceil();
      _generousDeeds = _reflectAndShareRepository.getAmountOfGenerousDeeds();
      _tagsWereSelected =
          _reflectAndShareRepository.hasAnyGenerousPowerBeenSelected();
      await getPlayerProfiles();
    } catch (e, s) {
      // it's ok to fail we can still show some data
    }

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
    _experienceStats = null;
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

  Future<void> doneButtonPressed() async {
    if (_audioPath.isNotEmpty) {
      await shareAudio(_audioPath);
    }

    final amountGamePlays =
        await _reflectAndShareRepository.getTotalGamePlays();

    if (await _shouldAskForAppReview(amountGamePlays)) {
      await AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.inAppReviewTriggered,
      );

      await InAppReview.instance.requestReview();
    }

    if (await _shouldAskForInterview(amountGamePlays)) {
      await AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.askForInterviewTriggered,
      );

      emitCustom(
        SummaryDetailsCustom.showInterviewPopup(
          FunDialogUIModel(
            title: _reflectAndShareRepository.getAskForInterviewTitle(),
            description: _reflectAndShareRepository.getAskForInterviewMessage(),
            primaryButtonText: 'Yes, I’m interested!',
            secondaryButtonText: 'No, thanks',
            showCloseButton: false,
          ),
          useDefaultImage: _reflectAndShareRepository.useDefaultInterviewIcon(),
        ),
      );
      return;
    }

    await navigateWithConfetti();
  }

  Future<bool> _shouldAskForAppReview(int gameplays) async {
    final playsBeforePopup =
        _reflectAndShareRepository.getStoreReviewMinimumGameCount();
    final isInAppReviewAvailable = await InAppReview.instance.isAvailable();
    return isInAppReviewAvailable && gameplays == (playsBeforePopup - 1);
  }

  Future<bool> _shouldAskForInterview(int gameplays) async {
    final playsBeforeInterview =
        _reflectAndShareRepository.getInterviewMinimumGameCount();
    return gameplays == (playsBeforeInterview - 1);
  }

  Future<void> navigateWithConfetti() async {
    onCloseGame();

    emitCustom(const SummaryDetailsCustom.showConfetti());

    Future<void>.delayed(const Duration(seconds: 1), () {
      emitCustom(const SummaryDetailsCustom.navigateToNextScreen());
    });
  }
}
