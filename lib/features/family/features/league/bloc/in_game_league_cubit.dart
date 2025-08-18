import 'dart:async';

import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/league/domain/league_repository.dart';
import 'package:givt_app/features/family/features/league/domain/models/league_item.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/models/in_game_league_screen_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/models/summary_details_custom.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_entry_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_overview_uimodel.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reward/presentation/models/reward_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/models/fun_dialog_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InGameLeagueCubit
    extends CommonCubit<InGameLeagueScreenUIModel, InGameLeagueCustom> {
  InGameLeagueCubit(
    this._profilesRepository,
    this._leagueRepository,
    this._reflectAndShareRepository,
    this._prefs,
  ) : super(const BaseState.loading());

  final ProfilesRepository _profilesRepository;
  final LeagueRepository _leagueRepository;
  final ReflectAndShareRepository _reflectAndShareRepository;
  final SharedPreferences _prefs;

  static const String _inGameLeagueExplanationKey = 'leagueExplanation';

  List<Profile> _profiles = [];
  List<LeagueItem> _league = [];
  bool _shouldShowExplanation = false;
  bool _shouldShowOnTopOfLeague = false;

  Future<void> init() async {
    try {
      emitLoading();
      final hasSeenLeagueExplanation =
          _prefs.getBool(_inGameLeagueExplanationKey) ?? false;
      _shouldShowExplanation = !hasSeenLeagueExplanation;
      _shouldShowOnTopOfLeague = !_shouldShowExplanation;
      _profiles = await _profilesRepository.getProfiles();
      _league = await _leagueRepository.fetchLeague();
    } catch (e) {
      // do nothing
    }
    _emitData();
  }

  void _emitData() {
    if (_league.isEmpty) {
      //skip
      _goToHome();
    } else if (_shouldShowExplanation) {
      emitData(const InGameLeagueScreenUIModel.showLeagueExplanation());
    } else if (_shouldShowOnTopOfLeague) {
      emitData(const InGameLeagueScreenUIModel.showWhosOnTop());
    } else {
      final entries = LeagueEntryUIModel.listFromEntriesAndProfiles(
        _league,
        _profiles,
      );
      emitData(
        InGameLeagueScreenUIModel.showLeague(
          LeagueOverviewUIModel(entries: entries, isInGameVersion: true),
        ),
      );
    }
  }

  void _goToHome() {
    emitCustom(const InGameLeagueCustom.navigateToProfileSelection());
  }

  void onExplanationContinuePressed() {
    _prefs.setBool(_inGameLeagueExplanationKey, true);
    _shouldShowExplanation = false;
    _shouldShowOnTopOfLeague = true;

    _showConfetti();
    Timer(const Duration(seconds: 1), _emitData);
  }

  void _showConfetti() {
    emitCustom(const InGameLeagueCustom.showConfetti());
  }

  void onWhosTopOfLeagueContinuePressed() {
    _shouldShowOnTopOfLeague = false;
    _emitData();
  }

  Future<void> onLeagueOverviewContinuePressed() async {
    final amountGamePlays =
        await _reflectAndShareRepository.getTotalGamePlays();

    final shouldAskForAppReview = await _shouldAskForAppReview(amountGamePlays);

    final shouldAskForInterview = await _shouldAskForInterview(amountGamePlays);

    // If there is a reward, redirect user to the reward screen
    final rewardText = _reflectAndShareRepository.variableReward;

    if (rewardText == null) {
      if (shouldAskForAppReview) {
        await AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.inAppReviewTriggered,
        );

        await InAppReview.instance.requestReview();
      }

      if (shouldAskForInterview) {
        await AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.askForInterviewTriggered,
        );

        emitCustom(
          InGameLeagueCustom.showInterviewPopup(
            _getInterviewUIModel(),
            useDefaultImage:
                _reflectAndShareRepository.useDefaultInterviewIcon(),
          ),
        );
        return;
      }
    } else {
      // Trigger profiles refresh
      unawaited(_profilesRepository.refreshProfiles());

      // Get reward context from the repository
      final rewardImage = _reflectAndShareRepository.variableRewardImage;
      final fullRewardImagePath = rewardImage == null
          ? null
          : 'assets/family/images/reward/$rewardImage';

      // Trigger navigation to the reward screen
      emitCustom(
        InGameLeagueCustom.navigateToRewardScreen(
          RewardUIModel(
            rewardText: rewardText,
            rewardImage: fullRewardImagePath,
            interviewUIModel:
                shouldAskForInterview ? _getInterviewUIModel() : null,
            useDefaultInterviewIcon:
                _reflectAndShareRepository.useDefaultInterviewIcon(),
            triggerAppReview: shouldAskForAppReview,
          ),
        ),
      );
      return;
    }

    _goToHome();
  }

  FunDialogUIModel _getInterviewUIModel() {
    return FunDialogUIModel(
      title: _reflectAndShareRepository.getAskForInterviewTitle(),
      description: _reflectAndShareRepository.getAskForInterviewMessage(),
      primaryButtonText: 'Yes, I’m interested!',
      secondaryButtonText: 'No, thanks',
      showCloseButton: false,
    );
  }

  Future<bool> _shouldAskForAppReview(int gameplays) async {
    final playsBeforePopup =
        _reflectAndShareRepository.getStoreReviewMinimumGameCount();
    final isInAppReviewAvailable = await InAppReview.instance.isAvailable();
    return isInAppReviewAvailable && gameplays == playsBeforePopup;
  }

  Future<bool> _shouldAskForInterview(int gameplays) async {
    final playsBeforeInterview =
        _reflectAndShareRepository.getInterviewMinimumGameCount();
    return gameplays == playsBeforeInterview;
  }
}
