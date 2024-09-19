import 'package:collection/collection.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/reflect/domain/grateful_recommendations_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_uimodel.dart';
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
  final List<Organisation> _currentRecommendations = [];

  Future<void> init() async {
    _initProfiles();

    await _gratefulRecommendationsRepository
        .getGratefulRecommendationsForMultipleProfiles(_profiles);
        
    final _currentRecommendations = await _gratefulRecommendationsRepository
        .getGratefulRecommendations(_getCurrentProfile());

    _emitData();
  }

  void _initProfiles() {
    // Make copy of list to avoid mutation of original repository list
    _profiles = List.from(_reflectAndShareRepository.getPlayers());

    _profiles
      ..sort((a, b) => a.isChild ? -1 : 1)
      ..removeWhere(
        (element) => !element.isChild || element.gratitude == null,
      ); //in the future we don't need to remove the adults

    if (_profiles.isEmpty) {
      _onEveryoneDonated();
    }
  }

  GameProfile _getCurrentProfile() => _profiles[_currentProfileIndex];

  void _emitData() {
    //TODO map above fields to uimodels
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
        recommendationsUIModel: null,
      ),
    );
  }

  void onAvatarTapped(int index) {
    _currentProfileIndex = index;
    _emitData();
  }

  void onRecommendationTapped(int index) {
    //TODO
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

  void onDonated(GameProfile profile) {
    //TODO
    _profilesThatDonated.add(profile);
    if (_profilesThatDonated.length == _profiles.length) {
      _onEveryoneDonated();
    } else {
      //TODO (this does not work because in the design you can switch profiles and donate out of order)
      _currentProfileIndex++;
      _emitData();
    }
  }

  void _onEveryoneDonated() {
    emitCustom(const GratefulCustom.goToGameSummary());
  }

  bool isCurrentProfileChild() {
    //TODO
    return true;
  }
}
