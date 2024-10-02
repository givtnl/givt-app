import 'dart:async';

import 'package:collection/collection.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_custom.dart';
import 'package:givt_app/features/family/features/home_screen/usecases/family_setup_usecase.dart';
import 'package:givt_app/features/family/features/home_screen/usecases/preferred_church_usecase.dart';
import 'package:givt_app/features/family/features/home_screen/usecases/registration_use_case.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class NavigationBarHomeCubit
    extends CommonCubit<String?, NavigationBarHomeCustom>
    with PreferredChurchUseCase, RegistrationUseCase, FamilySetupUseCase {
  NavigationBarHomeCubit(this._profilesRepository, this._authRepository,
      this._impactGroupsRepository)
      : super(const BaseState.initial());

  final ProfilesRepository _profilesRepository;
  final AuthRepository _authRepository;
  final ImpactGroupsRepository _impactGroupsRepository;

  StreamSubscription<List<Profile>>? _profilesSubscription;
  String? profilePictureUrl;

  void onDidChangeDependencies() {
    _profilesSubscription = _profilesRepository
        .onProfilesChanged()
        .listen((_) => _getProfilePictureUrl());
    _getProfilePictureUrl();
    _doInitialChecks();
  }

  Future<void> _doInitialChecks() async {
    final group = await isInvitedToGroup();
    if (group != null) {
      emitCustom(NavigationBarHomeCustom.showFamilyInvite(group));
    } else if (await userNeedsRegistration()) {
      emitCustom(const NavigationBarHomeCustom.userNeedsRegistration());
    } else if (await hasNoFamilySetup()) {
      final cachedMembers = await getCachedMembers();
      if (cachedMembers.isNotEmpty) {
        emitCustom(
          NavigationBarHomeCustom.showCachedMembersDialog(cachedMembers),
        );
      } else {
        emitCustom(const NavigationBarHomeCustom.familyNotSetup());
      }
    } else if (await shouldShowPreferredChurchModal()) {
      setPreferredChurchModalShown();
    }
  }

  Future<ImpactGroup?> isInvitedToGroup() async {
    try {
      return _impactGroupsRepository.isInvitedToGroup();
    } catch (e, s) {
      return null;
    }
  }

  @override
  Future<void> close() async {
    await _profilesSubscription?.cancel();
    return super.close();
  }

  Future<void> _getProfilePictureUrl() async {
    try {
      final profiles = await _profilesRepository.getProfiles();
      final session = await _authRepository.getStoredSession();
      final profile = profiles
          .firstWhereOrNull((element) => element.id == session?.userGUID);
      profilePictureUrl = profile?.pictureURL;
      _emitData();
    } catch (e, s) {
      _emitData();
    }
  }

  void _emitData() => emitData(profilePictureUrl);
}
