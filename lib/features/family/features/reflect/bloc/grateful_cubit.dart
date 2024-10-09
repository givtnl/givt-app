import 'package:collection/collection.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/models/models.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/reflect/domain/grateful_recommendations_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/recommendations_ui_model.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class GratefulCubit extends CommonCubit<GratefulUIModel, GratefulCustom> {
  GratefulCubit(
    this._reflectAndShareRepository,
    this._gratefulRecommendationsRepository,
    this._authRepository,
  ) : super(const BaseState.loading());

  final ReflectAndShareRepository _reflectAndShareRepository;
  final GratefulRecommendationsRepository _gratefulRecommendationsRepository;
  final AuthRepository _authRepository;

  List<GameProfile> _profiles = [];
  final List<GameProfile> _profilesThatDonated = [];
  int _currentProfileIndex = 0;
  List<Organisation> _currentRecommendations = [];
  bool _hasRecommendationsError = false;
  bool _isLoadingRecommendations = false;
  Session? _session;

  Future<void> init() async {
    try {
      await _getSession();
      _initProfiles();

      await _gratefulRecommendationsRepository
          .fetchGratefulRecommendationsForMultipleProfiles(_profiles);

      await _fetchRecommendationsForCurrentProfile();
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
      _hasRecommendationsError = true;
      _emitData();
    }
  }

  Future<void> _getSession() async {
    try {
      _session = await _authRepository.getStoredSession();
    } catch (e, s) {
      //it's ok if we can't get the session
      // as a fallback we don't show any parent profiles
      // as we can't distinguish between logged in and
      // non-logged in parents without the session object
      LoggingInfo.instance.logExceptionForDebug(
        e,
        stacktrace: s,
      );
    }
  }

  void _initProfiles() {
    // Make copy of list to avoid mutation of original repository list
    _profiles = List.from(_reflectAndShareRepository.getPlayers());

    _profiles
      ..sort((a, b) => a.isChild ? -1 : 1)
      ..removeWhere(
        (element) => element.gratitude == null || _isNonLoggedInParent(element),
      );

    if (_profiles.isEmpty) {
      _onEveryoneDonated();
    }
  }

  GameProfile _getCurrentProfile() {
    try {
      final profile = _profiles[_currentProfileIndex];
      return profile;
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
      _initProfiles();
      _currentProfileIndex = 0;
      return _profiles[_currentProfileIndex];
    }
  }

  void _emitData() {
    emitData(
      GratefulUIModel(
        avatarBarUIModel: GratefulAvatarBarUIModel(
          avatarUIModels: _profiles
              .mapIndexed(
                (
                  index,
                  profile,
                ) =>
                    profile.toGratefulAvatarUIModel(
                  isSelected: index == _currentProfileIndex,
                  hasDonated: _profilesThatDonated.contains(profile),
                ),
              )
              .toList(),
        ),
        recommendationsUIModel: RecommendationsUIModel(
            isLoading: _isLoadingRecommendations,
            hasError: _hasRecommendationsError,
            organisations: _currentRecommendations,
            name: _profiles.elementAtOrNull(_currentProfileIndex)?.firstName ??
                '',
            category: _profiles.elementAt(_currentProfileIndex).gratitude),
      ),
    );
  }

  Future<void> onAvatarTapped(int index) async {
    _currentProfileIndex = index;
    await _fetchRecommendationsForCurrentProfile();
  }

  Future<void> _fetchRecommendationsForCurrentProfile() async {
    try {
      _isLoadingRecommendations = true;
      _emitData();
      _currentRecommendations = await _gratefulRecommendationsRepository
          .getOrganisationsRecommendations(_getCurrentProfile());
      _hasRecommendationsError = false;
    } catch (e, s) {
      _hasRecommendationsError = true;
      LoggingInfo.instance.logExceptionForDebug(
        e,
        stacktrace: s,
      );
    } finally {
      _isLoadingRecommendations = false;
      _emitData();
    }
  }

  void onRecommendationChosen(int index) {
    final organisation = _currentRecommendations[index];
    if (isCurrentProfileChild()) {
      emitCustom(
        GratefulCustom.openKidDonationFlow(
          profile: _getCurrentProfile(),
          organisation: organisation,
        ),
      );
    } else {
      emitCustom(
        GratefulCustom.openParentDonationFlow(
          profile: _getCurrentProfile(),
          organisation: organisation,
        ),
      );
    }
  }

  Future<void> onParentDonated(String userId) async {
    final parent = _profiles.firstWhere(
      (e) => e.userId == userId,
      orElse: () =>
          throw Exception('Parent profile not found for userId: $userId'),
    );
    await onDonated(parent);
  }

  Future<void> onDonated(GameProfile profile) async {
    _reflectAndShareRepository.incrementGenerousDeeds();
    _profilesThatDonated.add(profile);
    if (_profilesThatDonated.length == _profiles.length) {
      _onEveryoneDonated();
    } else {
      final nextGiver = _profiles.firstWhere(
        (profile) => !_profilesThatDonated.contains(profile),
        orElse: () {
          _onEveryoneDonated();
          throw Exception('No next giver found');
        },
      );
      _currentProfileIndex = _profiles.indexOf(nextGiver);
      await _fetchRecommendationsForCurrentProfile();
    }
  }

  void _onEveryoneDonated() {
    emitCustom(const GratefulCustom.goToGameSummary());
  }

  bool isCurrentProfileChild() => _getCurrentProfile().isChild;

  void onRetry() {
    _fetchRecommendationsForCurrentProfile();
  }

  bool _isNonLoggedInParent(GameProfile element) {
    return !element.isChild &&
        (_session?.userGUID == null || element.userId != _session?.userGUID);
  }
}
