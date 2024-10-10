import 'package:collection/collection.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/family_home_screen.uimodel.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_uimodel.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class FamilyHomeScreenCubit
    extends CommonCubit<FamilyHomeScreenUIModel, FamilyHomeScreenUIModel> {
  FamilyHomeScreenCubit(
    this._profilesRepository,
    this._impactGroupsRepository,
  ) : super(const BaseState.loading());

  final ProfilesRepository _profilesRepository;
  final ImpactGroupsRepository _impactGroupsRepository;

  List<Profile> profiles = [];
  ImpactGroup? _familyGroup;

  Future<void> init() async {
    _profilesRepository.onProfilesChanged().listen(_onProfilesChanged);
    _impactGroupsRepository.onImpactGroupsChanged().listen(_onGroupsChanged);

    profiles = await _profilesRepository.getProfiles();

    _familyGroup =
        (await _impactGroupsRepository.getImpactGroups()).firstWhereOrNull(
      (element) => element.isFamilyGroup,
    );

    _emitData();
  }

  void _onProfilesChanged(List<Profile> profiles) {
    _emitData();
  }

  void _onGroupsChanged(List<ImpactGroup> profiles) {
    _familyGroup = profiles.firstWhereOrNull(
      (element) => element.isFamilyGroup,
    );

    _emitData();
  }

  void onGiveButtonPressed() {
    emitCustom(_createUIModel());
  }

  void _emitData() {
    emitData(
      _createUIModel(),
    );
  }

  FamilyHomeScreenUIModel _createUIModel() {
    profiles.sort((a, b) => a.isChild ? -1 : 1);
    return FamilyHomeScreenUIModel(
      avatars: profiles
          .map(
            (e) => GratefulAvatarUIModel(
              avatarUrl: e.pictureURL,
              text: e.firstName,
            ),
          )
          .toList(),
      familyGroupName: _familyGroup?.name,
    );
  }
}
