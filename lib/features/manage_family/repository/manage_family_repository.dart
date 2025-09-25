import 'dart:async';
import 'package:collection/collection.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/manage_family/models/family_invite.dart';
import 'package:givt_app/features/manage_family/models/family_member.dart';
import 'package:givt_app/features/manage_family/models/group_invite.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';
import 'package:givt_app/features/family/features/impact_groups/models/impact_group.dart';

abstract class ManageFamilyRepository {
  Future<List<FamilyMember>> getFamilyMembers();
  Future<List<FamilyInvite>> getFamilyInvites();
  Future<List<GroupInvite>> getGroupInvites();
  Future<String?> getFamilyGroupName();
  Future<void> createFamilyInvite(String email, {String? message});
  Future<void> cancelFamilyInvite(String inviteId);
  Future<void> acceptGroupInvite(String groupId);
  Future<void> declineGroupInvite(String groupId);
  Future<void> removeFamilyMember(String memberId);
  Future<void> updateMemberRole(String memberId, FamilyMemberRole role);
  Stream<List<FamilyMember>> onMembersChanged();
  Stream<List<FamilyInvite>> onInvitesChanged();
  Stream<List<GroupInvite>> onGroupInvitesChanged();
}

class FamilyManagementRepositoryImpl implements ManageFamilyRepository {
  FamilyManagementRepositoryImpl(
    this._apiService,
    this._familyApiService,
  );

  final APIService _apiService;
  final FamilyAPIService _familyApiService;

  final StreamController<List<FamilyMember>> _membersStreamController =
      StreamController<List<FamilyMember>>.broadcast();
  final StreamController<List<FamilyInvite>> _invitesStreamController =
      StreamController<List<FamilyInvite>>.broadcast();
  final StreamController<List<GroupInvite>> _groupInvitesStreamController =
      StreamController<List<GroupInvite>>.broadcast();

  // Impact groups data management
  List<ImpactGroup>? _impactGroups;

  @override
  Future<List<FamilyMember>> getFamilyMembers() async {
    try {
      // Use the same API endpoint as the family side
      final response = await _familyApiService.fetchAllProfiles();

      print('DEBUG: fetchAllProfiles response length: ${response.length}');

      final members = <FamilyMember>[];
      for (final profileMap in response) {
        final profileData = profileMap as Map<String, dynamic>;

        print('DEBUG: profileData keys: ${profileData.keys.toList()}');
        print(
          'DEBUG: firstName: ${profileData['firstName']}, lastName: ${profileData['lastName']}',
        );

        // Try different possible avatar field names
        String? avatarUrl;

        if (profileData['picture'] != null) {
          final picture = profileData['picture'] as Map<String, dynamic>;
          avatarUrl = picture['pictureURL'] as String?;
        }

        if (avatarUrl == null || avatarUrl.isEmpty) {
          avatarUrl = profileData['avatar'] as String?;
        }

        if (avatarUrl == null || avatarUrl.isEmpty) {
          avatarUrl = profileData['pictureURL'] as String?;
        }

        final member = FamilyMember(
          id: profileData['id'] as String? ?? '',
          firstName: profileData['firstName'] as String? ?? '',
          lastName: profileData['lastName'] as String? ?? '',
          email: profileData['email'] as String? ?? '',
          avatar: avatarUrl,
          isActive: profileData['isActive'] as bool? ?? false,
          role: FamilyMemberRole.fromString(
            profileData['role'] as String? ?? 'member',
          ),
          inviteStatus: FamilyMemberInviteStatus
              .accepted, // All fetched members are accepted
        );

        print('DEBUG: created member: ${member.fullName} (${member.email})');
        members.add(member);
      }

      print('DEBUG: total members: ${members.length}');
      _membersStreamController.add(members);
      return members;
    } catch (e) {
      print('DEBUG: error fetching members: $e');
    }

    return [];
  }

  @override
  Future<List<FamilyInvite>> getFamilyInvites() async {
    try {
      // For now, return empty list as we'll implement invites later
      // This would typically call an API endpoint like /givtservice/v1/family/invites
      final invites = <FamilyInvite>[];
      _invitesStreamController.add(invites);
      return invites;
    } catch (e) {
      _invitesStreamController.addError(e);
      rethrow;
    }
  }

  @override
  Future<List<GroupInvite>> getGroupInvites() async {
    try {
      // Get all impact groups and filter for invited ones
      final impactGroups = await _getImpactGroups();
      final invitedGroups = impactGroups
          .where((group) => group.status == ImpactGroupStatus.invited)
          .map((group) => GroupInvite.fromImpactGroup(group))
          .toList();
      
      _groupInvitesStreamController.add(invitedGroups);
      return invitedGroups;
    } catch (e) {
      _groupInvitesStreamController.addError(e);
      rethrow;
    }
  }

  @override
  Future<void> createFamilyInvite(String email, {String? message}) async {
    try {
      // Use the same API endpoint as the family side for adding members
      final body = {
        'profiles': [
          {
            'firstName': '',
            'lastName': '',
            'email': email,
            'type': 'Parent', // Default to Parent for EU invites
          },
        ],
        'allowanceType': 1, // EU doesn't use RGA
        'isInvite': true, // Flag to indicate this is an invite
        if (message != null) 'message': message,
      };

      await _apiService.addMember(body);

      // Refresh invites after creating one
      await getFamilyInvites();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> cancelFamilyInvite(String inviteId) async {
    try {
      // This would typically call an API endpoint like /givtservice/v1/family/invites/$inviteId/cancel
      // For now, just refresh the invites
      await getFamilyInvites();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> acceptGroupInvite(String groupId) async {
    try {
      await _apiService.acceptGroupInvite(groupId);
      // Refresh impact groups after accepting one
      await _fetchImpactGroups();
      // Refresh group invites
      await getGroupInvites();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> declineGroupInvite(String groupId) async {
    try {
      await _apiService.declineGroupInvite(groupId);
      // Refresh impact groups after declining one
      await _fetchImpactGroups();
      // Refresh group invites
      await getGroupInvites();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFamilyMember(String memberId) async {
    try {
      // This would typically call an API endpoint like /givtservice/v1/family/members/$memberId
      // For now, just refresh the members
      await getFamilyMembers();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateMemberRole(String memberId, FamilyMemberRole role) async {
    try {
      // This would typically call an API endpoint like /givtservice/v1/family/members/$memberId/role
      // For now, just refresh the members
      await getFamilyMembers();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<FamilyMember>> onMembersChanged() {
    return _membersStreamController.stream;
  }

  @override
  Stream<List<FamilyInvite>> onInvitesChanged() {
    return _invitesStreamController.stream;
  }

  @override
  Stream<List<GroupInvite>> onGroupInvitesChanged() {
    return _groupInvitesStreamController.stream;
  }

  @override
  Future<String?> getFamilyGroupName() async {
    try {
      final impactGroups = await _getImpactGroups();
      return impactGroups
          .firstWhereOrNull((element) => element.isFamilyGroup)
          ?.name;
    } catch (e) {
      return null;
    }
  }

  // Private methods for impact groups management
  Future<List<ImpactGroup>> _getImpactGroups({bool fetchWhenEmpty = false}) async {
    if (fetchWhenEmpty && true == _impactGroups?.isEmpty) {
      _impactGroups = await _fetchImpactGroups();
    }
    return _impactGroups ??= await _fetchImpactGroups();
  }

  Future<List<ImpactGroup>> _fetchImpactGroups() async {
    final result = await _apiService.fetchImpactGroups();
    final list = result
        .map((e) => ImpactGroup.fromMap(e as Map<String, dynamic>))
        .toList();
    _impactGroups = list;
    return list;
  }

  void dispose() {
    _membersStreamController.close();
    _invitesStreamController.close();
    _groupInvitesStreamController.close();
  }
}
