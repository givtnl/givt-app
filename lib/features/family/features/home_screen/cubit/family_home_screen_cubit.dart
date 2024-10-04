import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/cached_members/repositories/cached_members_repository.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/family_home_screen.uimodel.dart';
import 'package:givt_app/features/family/features/home_screen/usecases/family_setup_usecase.dart';
import 'package:givt_app/features/family/features/home_screen/usecases/preferred_church_usecase.dart';
import 'package:givt_app/features/family/features/home_screen/usecases/registration_use_case.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_uimodel.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class FamilyHomeScreenCubit
    extends CommonCubit<FamilyHomeScreenUIModel, dynamic>
    with PreferredChurchUseCase, RegistrationUseCase, FamilySetupUseCase {
  FamilyHomeScreenCubit(
    this._profilesRepository,
    this._impactGroupsRepository,
  ) : super(const BaseState.loading());

  final ProfilesRepository _profilesRepository;
  final ImpactGroupsRepository _impactGroupsRepository;

  String? profilePictureUrl;
  List<Profile> _profiles = [];
  List<Member>? cachedMembers;
  ImpactGroup? _familyGroup;

  Future<void> init() async {
    _profilesRepository.onProfilesChanged().listen(_onProfilesChanged);
    _impactGroupsRepository.onImpactGroupsChanged().listen(_onGroupsChanged);

    _profiles = await _profilesRepository.getProfiles();
    _familyGroup = (await _impactGroupsRepository.getImpactGroups()).firstWhere(
      (element) => element.isFamilyGroup,
    );

    _updateUiModel();
  }

  void _onProfilesChanged(List<Profile> profiles) {
    _profiles = profiles;

    _updateUiModel();
  }

  void _onGroupsChanged(List<ImpactGroup> profiles) {
    _familyGroup = profiles.firstWhere(
      (element) => element.isFamilyGroup,
    );

    _updateUiModel();
  }

  void _updateUiModel() {
    emitData(
      FamilyHomeScreenUIModel(
        avatars: _profiles
            .map((e) => GratefulAvatarUIModel(
                  avatarUrl: e.pictureURL,
                  text: e.firstName,
                ))
            .toList(),
        familyGroupName: _familyGroup?.name ?? '',
      ),
    );
  }
}
