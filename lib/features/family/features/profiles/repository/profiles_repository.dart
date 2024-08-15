import 'dart:async';

import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';
import 'package:givt_app/features/children/edit_child/repositories/edit_child_repository.dart';
import 'package:givt_app/features/children/parental_approval/repositories/parental_approval_repository.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/network/api_service.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

mixin ProfilesRepository {
  Future<Profile> getChildDetails(String childGuid);

  Future<List<Profile>> getProfiles();

  // this method should only be called externally when the screen itself
  // has a refresh mechanism for the user
  Future<List<Profile>> refreshProfiles();

  Stream<List<Profile>> profilesStream();

  Stream<Profile> childDetailsStream();
}

class ProfilesRepositoryImpl with ProfilesRepository {
  ProfilesRepositoryImpl(
    this._apiService,
    this._editChildRepository,
    this._addMemberRepository,
    this._impactGroupsRepository,
    this._givtRepository,
    this._authRepository,
    this._parentalApprovalRepository,
  ) {
    _init();
  }

  final FamilyAPIService _apiService;
  final EditChildRepository _editChildRepository;
  final AddMemberRepository _addMemberRepository;
  final ImpactGroupsRepository _impactGroupsRepository;
  final GivtRepository _givtRepository;
  final AuthRepository _authRepository;
  final ParentalApprovalRepository _parentalApprovalRepository;

  final StreamController<List<Profile>> _profilesStreamController =
      StreamController<List<Profile>>.broadcast();
  final StreamController<Profile> _childDetailsStreamController =
      StreamController<Profile>.broadcast();

  List<Profile>? _profiles;
  final Map<String, Profile> _profileMap = {};
  Completer<List<Profile>> _profilesCompleter = Completer<List<Profile>>();

  void _init() {
    _addMemberRepository.memberAddedStream().listen(
          (_) => _fetchProfiles(),
        );

    _editChildRepository.childChangedStream().listen(_fetchChildDetails);

    _impactGroupsRepository.onImpactGroupsChanged().listen(
          (_) => _fetchProfiles(),
        );

    _givtRepository.onGivtsChanged().listen(
          (_) => _fetchProfiles(),
        );

    _parentalApprovalRepository.onParentalApprovalChanged().listen(
          (_) => _fetchProfiles(),
        );

    _authRepository.hasSessionStream().listen(
          (_) => _clearData(),
        );
  }

  void _clearData() {
    _profiles = null;
    _profileMap.clear();
  }

  @override
  Future<List<Profile>> getProfiles() async {
    await _profilesCompleter.future;
    return _profiles ??= await _fetchProfiles();
  }

  Future<List<Profile>> _fetchProfiles() async {
    try {
      _profilesCompleter = Completer<List<Profile>>();
      final response = await _apiService.fetchAllProfiles();
      final result = <Profile>[];
      for (final profileMap in response) {
        result.add(Profile.fromMap(profileMap as Map<String, dynamic>));
      }
      _profilesStreamController.add(result);
      _profilesCompleter.complete(result);
      return result;
    } catch (e) {
      rethrow;
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
    return profile;
  }

  @override
  Stream<List<Profile>> profilesStream() => _profilesStreamController.stream;

  @override
  Stream<Profile> childDetailsStream() => _childDetailsStreamController.stream;

  @override
  Future<List<Profile>> refreshProfiles() => _fetchProfiles();
}
