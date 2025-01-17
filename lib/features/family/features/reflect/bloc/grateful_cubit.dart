import 'package:collection/collection.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/models/models.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/areas.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/features/family/features/reflect/domain/grateful_recommendations_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/recommendations_ui_model.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_bar_uimodel.dart';
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

  static const int _actsOfServiceIndex = 0;

  List<GameProfile> _profiles = [];
  final List<GameProfile> _profilesThatDonated = [];
  int _currentProfileIndex = 0;
  List<Organisation> _currentOrganisations = [];
  List<Organisation> _currentActsOfService = [];
  int tabIndex = _actsOfServiceIndex;
  bool _hasRecommendationsError = false;
  bool _isLoadingRecommendations = false;
  Session? _session;
  List<String> tabsOptions = const ['Help', 'Give'];

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
        (element) => element.gratitude == null,
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
        avatarBarUIModel: AvatarBarUIModel(
          avatarUIModels: _profiles
              .mapIndexed(
                (
                  index,
                  profile,
                ) =>
                    profile.toAvatarUIModel(
                  isSelected: index == _currentProfileIndex,
                  hasDonated: _profilesThatDonated.contains(profile),
                ),
              )
              .toList(),
        ),
        recommendationsUIModel: RecommendationsUIModel(
          tabIndex: tabIndex,
          isLoading: _isLoadingRecommendations,
          hasError: _hasRecommendationsError,
          organisations: _isActsOfServiceIndexCurrentlySelected()
              ? _overrideTags(_currentActsOfService)
              : _overrideTags(_currentOrganisations),
          isNotLoggedInParent: _isNonLoggedInParent(_getCurrentProfile()),
          name: _getCurrentProfile().firstName,
          category: _getCurrentProfile().gratitude,
          isShowingActsOfService: _isActsOfServiceIndexCurrentlySelected(),
        ),
      ),
    );
  }

  List<Organisation> _overrideTags(List<Organisation> organisations) {
    return organisations.map((organisation) {
      return organisation.copyWith(
        tags: [
          Tag(
            key: 'override',
            displayText: _isActsOfServiceIndexCurrentlySelected()
                ? 'Way to help'
                : 'Give',
            area: _isActsOfServiceIndexCurrentlySelected()
                ? Areas.tertiary
                : Areas.primary,
            pictureUrl: '',
            type: TagType.INTERESTS,
          ),
        ],
      );
    }).toList();
  }

  bool _isActsOfServiceIndexCurrentlySelected() =>
      tabIndex == _actsOfServiceIndex;

  Future<void> onAvatarTapped(int index) async {
    _currentProfileIndex = index;
    await _fetchRecommendationsForCurrentProfile();
    resetTabs();
  }

  Future<void> _fetchRecommendationsForCurrentProfile() async {
    try {
      _isLoadingRecommendations = true;
      _emitData();
      final profile = _getCurrentProfile();
      _currentActsOfService = (await _gratefulRecommendationsRepository
          .getActsRecommendations(profile))
        ..shuffle();
      if (_isNonLoggedInParent(profile)) {
        _currentOrganisations = [];
      } else {
        _currentOrganisations = await _gratefulRecommendationsRepository
            .getOrganisationsRecommendations(profile);
      }
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

  void resetTabs() {
    onSelectionChanged({tabsOptions[0]});
    emitCustom(const GratefulCustom.scrollToTop());
  }

  void onSelectionChanged(Set<String> set) {
    if (set.isEmpty || !tabsOptions.contains(set.first)) {
      return;
    }
    tabIndex = set.first == tabsOptions.first ? 0 : 1;
    _emitData();
  }

  Future<void> saveActOfService(Organisation organisation) async {
    try {
      await _gratefulRecommendationsRepository.savePledge(
        _getCurrentProfile(),
        organisation,
        _reflectAndShareRepository.getGameId(),
      );
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
    }
  }

  void onSkip() {
    onDeed(_getCurrentProfile(), skip: true);
  }

  void onRecommendationChosen(int index) {
    final organisation = _isActsOfServiceIndexCurrentlySelected()
        ? _currentActsOfService[index]
        : _currentOrganisations[index];
    if (_isActsOfServiceIndexCurrentlySelected()) {
      emitCustom(
        GratefulCustom.openActOfServiceSuccess(
          organisation: organisation,
          profile: _getCurrentProfile(),
        ),
      );
    } else if (isCurrentProfileChild()) {
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
    await onDeed(parent);
  }

  Future<void> onDeed(GameProfile profile, {bool skip = false}) async {
    if (!skip) {
      _reflectAndShareRepository.incrementGenerousDeeds();
    }

    _profilesThatDonated.add(profile);
    if (_profilesThatDonated.length == _profiles.length) {
      _onEveryoneDonated();
      return;
    }

    final nextGiver = _profiles.firstWhere(
      (profile) => !_profilesThatDonated.contains(profile),
      orElse: () {
        _onEveryoneDonated();
        throw Exception('No next giver found');
      },
    );

    if (skip) {
      emitCustom(const GratefulCustom.showSkippedOverlay());
    } else {
      emitCustom(const GratefulCustom.showDoneOverlay());
    }

    _currentProfileIndex = _profiles.indexOf(nextGiver);
    resetTabs();
    await _fetchRecommendationsForCurrentProfile();
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
