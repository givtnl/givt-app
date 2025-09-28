import 'dart:async';
import 'package:collection/collection.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';
import 'package:givt_app/features/family/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/manage_family/models/family_member.dart';

/// Abstract repository for managing family group information.
/// This repository provides a shared interface for accessing family group data
/// across different features like donation overview and family management.
abstract class FamilyGroupRepository {
  /// Get all family members in the current group
  Future<List<FamilyMember>> getFamilyMembers();
  
  /// Get the family group name
  Future<String?> getFamilyGroupName();
  
  /// Get a family member by their ID
  Future<FamilyMember?> getFamilyMemberById(String memberId);
  
  /// Get a family member by their GUID
  Future<FamilyMember?> getFamilyMemberByGuid(String guid);
  
  /// Stream of family members changes
  Stream<List<FamilyMember>> onMembersChanged();
  
  /// Check if the repository has cached data
  bool hasCachedData();
  
  /// Force refresh the data
  Future<void> refresh();
}

/// Implementation of the family group repository.
/// Uses caching to avoid unnecessary API calls and provides shared access
/// to family group information across the app.
class FamilyGroupRepositoryImpl implements FamilyGroupRepository {
  FamilyGroupRepositoryImpl(
    this._apiService,
    this._familyApiService,
  );

  final APIService _apiService;
  final FamilyAPIService _familyApiService;

  final StreamController<List<FamilyMember>> _membersStreamController =
      StreamController<List<FamilyMember>>.broadcast();

  // Cached data
  List<FamilyMember>? _cachedMembers;
  List<ImpactGroup>? _cachedImpactGroups;
  String? _cachedFamilyGroupName;

  @override
  Future<List<FamilyMember>> getFamilyMembers() async {
    if (_cachedMembers != null) {
      return _cachedMembers!;
    }

    try {
      // Use the same API endpoint as the family side
      final response = await _familyApiService.fetchAllProfiles();

      final members = <FamilyMember>[];
      for (final profileMap in response) {
        try {
          final member = FamilyMember.fromJson(profileMap as Map<String, dynamic>);
          members.add(member);
        } catch (e) {
          // Skip invalid profiles
          continue;
        }
      }

      _cachedMembers = members;
      _membersStreamController.add(members);
      return members;
    } catch (e) {
      _membersStreamController.addError(e);
      rethrow;
    }
  }

  @override
  Future<String?> getFamilyGroupName() async {
    if (_cachedFamilyGroupName != null) {
      return _cachedFamilyGroupName;
    }

    try {
      final impactGroups = await _getImpactGroups();
      final familyGroup = impactGroups
          .firstWhereOrNull((element) => element.isFamilyGroup);
      
      _cachedFamilyGroupName = familyGroup?.name;
      return _cachedFamilyGroupName;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<FamilyMember?> getFamilyMemberById(String memberId) async {
    final members = await getFamilyMembers();
    return members.firstWhereOrNull((member) => member.id == memberId);
  }

  @override
  Future<FamilyMember?> getFamilyMemberByGuid(String guid) async {
    final members = await getFamilyMembers();
    return members.firstWhereOrNull((member) => member.id == guid);
  }

  @override
  Stream<List<FamilyMember>> onMembersChanged() {
    return _membersStreamController.stream;
  }

  @override
  bool hasCachedData() {
    return _cachedMembers != null;
  }

  @override
  Future<void> refresh() async {
    // Clear cached data
    _cachedMembers = null;
    _cachedImpactGroups = null;
    _cachedFamilyGroupName = null;
    
    // Fetch fresh data
    await getFamilyMembers();
    await getFamilyGroupName();
  }

  // Private methods for impact groups management
  Future<List<ImpactGroup>> _getImpactGroups({bool fetchWhenEmpty = false}) async {
    if (fetchWhenEmpty && (_cachedImpactGroups?.isEmpty ?? true)) {
      _cachedImpactGroups = await _fetchImpactGroups();
    }
    return _cachedImpactGroups ??= await _fetchImpactGroups();
  }

  Future<List<ImpactGroup>> _fetchImpactGroups() async {
    final result = await _apiService.fetchImpactGroups();
    final list = result
        .map((e) => ImpactGroup.fromMap(e as Map<String, dynamic>))
        .toList();
    _cachedImpactGroups = list;
    return list;
  }

  void dispose() {
    _membersStreamController.close();
  }
}
