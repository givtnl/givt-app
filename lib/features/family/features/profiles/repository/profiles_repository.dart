import 'dart:async';

import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';
import 'package:givt_app/features/children/edit_child/repositories/edit_child_repository.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/network/api_service.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';

mixin ProfilesRepository {
  Future<Profile> getChildDetails(String childGuid);

  Future<List<Profile>> getProfiles();

  Stream<List<Profile>> profilesStream();

  Stream<Profile> childDetailsStream();
}

class ProfilesRepositoryImpl with ProfilesRepository {
  ProfilesRepositoryImpl(
    this._apiService,
    this._editChildRepository,
    this._addMemberRepository,
    this._impactGroupsRepository,
  ) {
    _init();
  }

  final FamilyAPIService _apiService;
  final EditChildRepository _editChildRepository;
  final AddMemberRepository _addMemberRepository;
  final ImpactGroupsRepository _impactGroupsRepository;

  StreamSubscription<void>? _memberAddedSubscription;
  StreamSubscription<String>? _walletChangedSubscription;
  StreamSubscription<void>? _groupInviteAcceptedSubscription;

  final StreamController<List<Profile>> _profilesStreamController =
      StreamController<List<Profile>>.broadcast();
  final StreamController<Profile> _childDetailsStreamController =
      StreamController<Profile>.broadcast();

  List<Profile>? _profiles;
  final Map<String, Profile> _profileMap = {};

  void _init() {
    _memberAddedSubscription = _addMemberRepository.memberAddedStream().listen(
      (_) {
        _fetchProfiles();
      },
    );
    _walletChangedSubscription =
        _editChildRepository.walletChangedStream().listen(
      (childGuid) {
        _fetchChildDetails(childGuid);
      },
    );
    _groupInviteAcceptedSubscription =
        _impactGroupsRepository.impactGroupsStream().listen(
      (_) {
        _fetchProfiles();
      },
    );
  }

  @override
  Future<List<Profile>> getProfiles() async {
    return _profiles ??= await _fetchProfiles();
  }

  Future<List<Profile>> _fetchProfiles() async {
    final response = await _apiService.fetchAllProfiles();
    final result = <Profile>[];
    for (final profileMap in response) {
      result.add(Profile.fromMap(profileMap as Map<String, dynamic>));
    }
    _profilesStreamController.add(result);
    return result;
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
}
