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
      this._reflectAndShareRepository, this._gratefulRecommendationsRepository)
      : super(const BaseState.loading());

  final ReflectAndShareRepository _reflectAndShareRepository;
  final GratefulRecommendationsRepository _gratefulRecommendationsRepository;

  List<GameProfile> _profiles = [];
  List<GameProfile> _profilesThatDonated = [];
  int _currentProfileIndex = 0;
  List<Organisation> _currentRecommendations = [];

  Future<void> init() async {
    //TODO
    _profiles = _reflectAndShareRepository.getPlayers();
    await _gratefulRecommendationsRepository
        .getGratefulRecommendationsForMultipleProfiles(_profiles);
    _currentRecommendations = await _gratefulRecommendationsRepository
        .getGratefulRecommendations(_getCurrentProfile());
    _emitData();
    //TODO sort kids first, then parents
  }

  GameProfile _getCurrentProfile() => _profiles[_currentProfileIndex];

  void _emitData() {
    //TODO map above fields to uimodels
    emitData(GratefulUIModel(
        avatarBarUIModel: GratefulAvatarBarUIModel(),
        recommendationsUIModel: null));
  }

  void onAvatarTapped(int index) {
    //TODO
  }

  void onRecommendationTapped(int index) {
    //TODO
    final organisation = _currentRecommendations[index];
    if (isCurrentProfileChild()) {
      emitCustom(GratefulCustom.openKidDonationFlow(
          profile: _getCurrentProfile(), organisation: organisation));
    } else {
      emitCustom(GratefulCustom.openParentDonationFlow(
          profile: _getCurrentProfile(), organisation: organisation));
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
