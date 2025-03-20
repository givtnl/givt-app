import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/add_member/repository/add_member_repository.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/edit_avatar/domain/edit_avatar_repository.dart';
import 'package:givt_app/features/family/features/edit_child_name/repositories/edit_child_repository.dart';
import 'package:givt_app/features/family/features/edit_parent_profile/repositories/edit_parent_profile_repository.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/repositories/create_transaction_repository.dart';
import 'package:givt_app/features/family/features/parental_approval/repositories/parental_approval_repository.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/repo/impact_groups_repository.dart';

mixin ProfilesRepository {
  Future<Profile> getChildDetails(String childGuid);

  Future<Profile> refreshChildDetails(String childGuid);

  Future<List<Profile>> getProfiles();

  // this method should only be called externally when the screen itself
  // has a refresh mechanism for the user
  Future<List<Profile>> refreshProfiles();

  Stream<List<Profile>> onProfilesChanged();

  Stream<Profile> onChildChanged();
}

class ProfilesRepositoryImpl with ProfilesRepository {
  ProfilesRepositoryImpl(
    this._apiService,
    this._editChildRepository,
    this._addMemberRepository,
    this._impactGroupsRepository,
    this._authRepository,
    this._parentalApprovalRepository,
    this._createTransactionRepository,
    this._editAvatarRepository,
    this._editParentProfileRepository,
  ) {
    _init();
  }

  final FamilyAPIService _apiService;
  final EditChildRepository _editChildRepository;
  final AddMemberRepository _addMemberRepository;
  final ImpactGroupsRepository _impactGroupsRepository;
  final FamilyAuthRepository _authRepository;
  final ParentalApprovalRepository _parentalApprovalRepository;
  final CreateTransactionRepository _createTransactionRepository;
  final EditAvatarRepository _editAvatarRepository;
  final EditParentProfileRepository _editParentProfileRepository;

  final StreamController<List<Profile>> _profilesStreamController =
      StreamController<List<Profile>>.broadcast();
  final StreamController<Profile> _childDetailsStreamController =
      StreamController<Profile>.broadcast();

  List<Profile>? _profiles;
  final Map<String, Profile> _profileMap = {};
  Completer<List<Profile>>? _profilesCompleter;

  void _init() {
    _addMemberRepository.onMemberAdded().listen((_) => refreshProfiles());

    _editChildRepository.childChangedStream().listen(refreshChildDetails);

    //_editAvatarRepository.onChildAvatarChanged().listen(refreshChildDetails);
    _editAvatarRepository.onAvatarChanged().listen((_) => refreshProfiles());

    _impactGroupsRepository.onImpactGroupsChanged().listen(
          (_) => refreshProfiles(),
        );

    _parentalApprovalRepository.onParentalApprovalChanged().listen(
          (_) => refreshProfiles(),
        );

    _authRepository.authenticatedUserStream().listen(
      (user) {
        if (user != null) {
          _clearData();
          refreshProfiles();
        } else {
          _clearData();
        }
      },
    );

    _createTransactionRepository.onTransactionByUser().listen((userId) {
      if (_profileMap.containsKey(userId) && _profileMap[userId]!.isChild) {
        refreshChildDetails(userId);
      } else {
        refreshProfiles();
      }
    });

    _editParentProfileRepository
        .onProfileChanged()
        .listen((_) => refreshProfiles());
  }

  void _clearData({bool updateListeners = true}) {
    _profiles = null;
    _profileMap.clear();
    _profilesCompleter = null;
    if (updateListeners) {
      _profilesStreamController.add([]);
      _childDetailsStreamController.add(Profile.empty());
    }
  }

  @override
  Future<List<Profile>> getProfiles() async {
    try {
      await _profilesCompleter?.future;
      return _profiles ??= await _fetchProfiles();
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(
        e,
        stacktrace: s,
      );
      return _profiles ?? [];
    }
  }

  Future<List<Profile>> _fetchProfiles() async {
    if (true == _profilesCompleter?.isCompleted) {
      return _doProfilesFetching();
    } else {
      return _profilesCompleter?.future ?? _doProfilesFetching();
    }
  }

  Future<List<Profile>> _doProfilesFetching() async {
    try {
      _profileMap.clear();
      _profilesCompleter = Completer<List<Profile>>();
      final response = await _apiService.fetchAllProfiles();
      debugPrint('Profiles fetched: $response');
      final result = <Profile>[];
      for (final profileMap in response) {
        result.add(Profile.fromMap(profileMap as Map<String, dynamic>));
      }
      if (!const ListEquality<Profile>().equals(_profiles, result)) {
        _profiles = result;
        _profilesStreamController.add(result);
      }

      return result;
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
      return _profiles ?? [];
    } finally {
      if (!_profilesCompleter!.isCompleted) {
        _profilesCompleter?.complete([]);
      }
    }
  }

  @override
  Future<Profile> getChildDetails(String childGuid) async {
    return _profileMap[childGuid] ??= await _fetchChildDetails(childGuid);
  }

  Future<Profile> _fetchChildDetails(String childGuid) async {
    final response = await _apiService.fetchChildDetails(childGuid);
    response['type'] = 'Child';
    final profile = Profile.fromMap(response);
    _childDetailsStreamController.add(profile);
    _profileMap[childGuid] = profile;
    final index = _profiles?.indexWhere((element) => element.id == childGuid);
    if (index != null && index != -1) {
      _profiles?[index] = profile;
      _profilesStreamController.add(_profiles!);
    }
    return profile;
  }

  @override
  Stream<List<Profile>> onProfilesChanged() => _profilesStreamController.stream;

  @override
  Stream<Profile> onChildChanged() => _childDetailsStreamController.stream;

  @override
  Future<List<Profile>> refreshProfiles() {
    _clearData(updateListeners: false);
    return _fetchProfiles();
  }

  @override
  Future<Profile> refreshChildDetails(String childGuid) async {
    _profileMap.remove(childGuid);
    try {
      await _fetchProfiles();
    } catch (e, s) {
      // it's okay if this one fails, we'll still refresh the specific child
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
    }

    return _fetchChildDetails(childGuid);
  }
}
