import 'dart:async';

import 'package:collection/collection.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/cached_members/repositories/cached_members_repository.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_custom.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_screen_uimodel.dart';
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
    extends CommonCubit<NavigationBarHomeScreenUIModel, NavigationBarHomeCustom>
    with PreferredChurchUseCase, RegistrationUseCase, FamilySetupUseCase {
  NavigationBarHomeCubit(
    this._profilesRepository,
    this._authRepository,
    this._impactGroupsRepository,
    this._cachedMembersRepository,
  ) : super(const BaseState.loading());

  final ProfilesRepository _profilesRepository;
  final AuthRepository _authRepository;
  final ImpactGroupsRepository _impactGroupsRepository;
  final CachedMembersRepository _cachedMembersRepository;

  String? profilePictureUrl;
  List<Profile> _profiles = [];
  List<Member>? cachedMembers;
  ImpactGroup? _familyInviteGroup;

  Future<void> init() async {
    _profilesRepository.onProfilesChanged().listen(_onProfilesChanged);
    _cachedMembersRepository
        .onCachedMembersChanged()
        .listen(_onCachedMembersChanged);
    _impactGroupsRepository.onImpactGroupsChanged().listen((_) {
      _onImpactGroupsChanged();
    });
    await refreshData();
  }

  Future<void> refreshData() async {
    _profiles = await _profilesRepository.getProfiles();
    _familyInviteGroup = await _impactGroupsRepository.isInvitedToGroup();
    cachedMembers = await getCachedMembers();
    unawaited(_getProfilePictureUrl());
    await doInitialChecks();
  }

  Future<void> _onCachedMembersChanged(List<Member> members) async {
    cachedMembers = members;
    _emitData();
    await doInitialChecks();
  }

  Future<void> _onImpactGroupsChanged() async {
    _familyInviteGroup = await _impactGroupsRepository.isInvitedToGroup();
    _emitData();
    await doInitialChecks();
  }

  Future<void> _onProfilesChanged(List<Profile> profiles) async {
    _profiles = profiles;
    unawaited(_getProfilePictureUrl());
    await doInitialChecks();
  }

  Future<void> doInitialChecks() async {
    final hasCachedMembers = true == cachedMembers?.isNotEmpty;
    if (_familyInviteGroup != null) {
      return;
    } else if (await userNeedsRegistration()) {
      emitCustom(const NavigationBarHomeCustom.userNeedsRegistration());
    } else if (hasCachedMembers) {
      emitCustom(
        NavigationBarHomeCustom.showCachedMembersDialog(cachedMembers!),
      );
    } else if (_profiles.length <= 1) {
      emitCustom(const NavigationBarHomeCustom.familyNotSetup());
    } else if (await shouldShowPreferredChurchModal()) {
      await setPreferredChurchModalShown();
      emitCustom(const NavigationBarHomeCustom.showPreferredChurchDialog());
    }
  }

  Future<ImpactGroup?> isInvitedToGroup() async {
    try {
      return _impactGroupsRepository.isInvitedToGroup();
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
      return null;
    }
  }

  Future<void> _getProfilePictureUrl() async {
    try {
      final session = await _authRepository.getStoredSession();
      final profile = _profiles
          .firstWhereOrNull((element) => element.id == session.userGUID);
      profilePictureUrl = profile?.pictureURL;
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
    } finally {
      _emitData();
    }
  }

  void _emitData() {
    if (_profiles.length > 1) {
      emitData(
        NavigationBarHomeScreenUIModel(
          cachedMembers: cachedMembers,
          profilePictureUrl: profilePictureUrl,
          familyInviteGroup: _familyInviteGroup,
        ),
      );
    } else {
      emitError(null);
    }
  }
}
