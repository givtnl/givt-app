import 'dart:async';

import 'package:collection/collection.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_custom.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_screen_uimodel.dart';
import 'package:givt_app/features/family/features/home_screen/usecases/preferred_church_usecase.dart';
import 'package:givt_app/features/family/features/home_screen/usecases/registration_usecase.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/registration/domain/registration_repository.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class NavigationBarHomeCubit
    extends CommonCubit<NavigationBarHomeScreenUIModel, NavigationBarHomeCustom>
    with PreferredChurchUseCase, RegistrationUseCase {
  NavigationBarHomeCubit(
    this._profilesRepository,
    this._authRepository,
    this._impactGroupsRepository,
    this._addMemberRepository,
    this._registrationRepository,
  ) : super(const BaseState.loading());

  final ProfilesRepository _profilesRepository;
  final AuthRepository _authRepository;
  final ImpactGroupsRepository _impactGroupsRepository;
  final AddMemberRepository _addMemberRepository;
  final FamilyRegistrationRepository _registrationRepository;

  String? profilePictureUrl;
  List<Profile> _profiles = [];
  ImpactGroup? _familyInviteGroup;
  bool _hasSession = false;

  Future<void> init() async {
    await _initHasSession();
    _addMemberRepository.onMemberAdded().listen((_) {
      if (_profiles.length <= 1) {
        emitLoading();
        refreshData();
      }
    });
    _profilesRepository.onProfilesChanged().listen(_onProfilesChanged);
    _impactGroupsRepository.onImpactGroupsChanged().listen((_) {
      _onImpactGroupsChanged();
    });
    _registrationRepository.onRegistrationFlowFinished().listen((_) {
      emitLoading();
      refreshData();
    });
    await refreshData();
  }

  Future<void> _initHasSession() async {
    try {
      final session = await _authRepository.getStoredSession();
      _hasSession = session.isLoggedIn;
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
    }
    _authRepository.hasSessionStream().listen((hasSession) {
      _hasSession = hasSession;
    });
  }

  Future<void> refreshData() async {
    _profiles = await _profilesRepository.getProfiles();
    _familyInviteGroup = await _impactGroupsRepository.isInvitedToGroup();
    unawaited(_getProfilePictureUrl());
    await doInitialChecks();
  }

  Future<void> _onImpactGroupsChanged() async {
    _profiles = await _profilesRepository.getProfiles();
    _familyInviteGroup = await _impactGroupsRepository.isInvitedToGroup();
    await doInitialChecks();
    _emitData();
  }

  Future<void> _onProfilesChanged(List<Profile> profiles) async {
    _profiles = profiles;
    unawaited(_getProfilePictureUrl());
    await doInitialChecks();
  }

  Future<void> doInitialChecks() async {
    if (!_hasSession) return;
    if (_familyInviteGroup != null) {
      return;
    } else if (await userNeedsToFillInPersonalDetails()) {
      return;
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
          profilePictureUrl: profilePictureUrl,
          familyInviteGroup: _familyInviteGroup,
        ),
      );
    } else {
      emitError(null);
    }
  }
}
