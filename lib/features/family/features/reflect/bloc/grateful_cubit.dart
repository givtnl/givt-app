import 'package:collection/collection.dart';
import 'package:givt_app/core/logging/logging.dart';
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
  ) : super(const BaseState.loading());

  final ReflectAndShareRepository _reflectAndShareRepository;
  final GratefulRecommendationsRepository _gratefulRecommendationsRepository;

  List<GameProfile> _profiles = [];
  final List<GameProfile> _profilesThatDonated = [];
  int _currentProfileIndex = 0;
  List<Organisation> _currentRecommendations = [];
  bool _hasRecommendationsError = false;
  bool _isLoadingRecommendations = false;

  Future<void> init() async {
    _initProfiles();

    await _gratefulRecommendationsRepository
        .fetchGratefulRecommendationsForMultipleProfiles(_profiles);

    await _fetchRecommendationsForCurrentProfile();
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

  GameProfile _getCurrentProfile() => _profiles[_currentProfileIndex];

  void _emitData() {
    //TODO map above fields to uimodels
    //_currentRecommendations

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
          name: _getCurrentProfile().firstName,
        ),
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
          .getGratefulRecommendations(_getCurrentProfile());
      _hasRecommendationsError = false;
    } catch (e, s) {
      _hasRecommendationsError = true;
      LoggingInfo.instance.logExceptionForDebug(
        e,
        stacktrace: s,
      );
    } finally {
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
    final parent = _profiles.firstWhere((e) => e.userId == userId);
    await onDonated(parent);
  }

  Future<void> onDonated(GameProfile profile) async {
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
}
