import 'dart:async';
import 'package:givt_app/features/eu_profile_selection/models/eu_profile.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class EuProfileRepository {
  Future<List<EuProfile>> getProfiles();
  List<EuProfile>? getProfilesSync();
  Future<void> addProfile(EuProfile profile);
  Future<void> updateProfile(EuProfile profile);
  Future<void> deleteProfile(String profileId);
  Future<void> setActiveProfile(String profileId);
  String? getActiveProfileId();
  Stream<List<EuProfile>> onProfilesChanged();
}

class EuProfileRepositoryImpl implements EuProfileRepository {
  EuProfileRepositoryImpl(
    this._prefs,
    this._apiService,
  );

  final SharedPreferences _prefs;
  final FamilyAPIService _apiService;
  
  static const String _profilesKey = 'eu_profiles';
  static const String _activeProfileKey = 'eu_active_profile_id';
  
  final StreamController<List<EuProfile>> _profilesStreamController =
      StreamController<List<EuProfile>>.broadcast();
  
  List<EuProfile>? _cachedProfiles;

  @override
  Future<List<EuProfile>> getProfiles() async {
    try {
      // Fetch profiles from the API (same as family side)
      final response = await _apiService.fetchAllProfiles();
      
      final profiles = <EuProfile>[];
      for (final profileMap in response) {
        final profileData = profileMap as Map<String, dynamic>;
        
        // Try different possible avatar field names
        String? avatarUrl;
        
        // First try: picture.pictureURL (based on the log structure)
        if (profileData['picture'] != null) {
          final picture = profileData['picture'] as Map<String, dynamic>;
          avatarUrl = picture['pictureURL'] as String?;
        }
        
        // Fallback to other possible fields
        if (avatarUrl == null || avatarUrl.isEmpty) {
          avatarUrl = profileData['avatar'] as String?;
        }
        
        if (avatarUrl == null || avatarUrl.isEmpty) {
          avatarUrl = profileData['pictureURL'] as String?;
        }
        
        final profile = EuProfile(
          id: profileData['id'] as String? ?? '',
          name: '${profileData['firstName'] ?? ''} ${profileData['lastName'] ?? ''}'.trim(),
          email: profileData['email'] as String? ?? '',
          avatar: avatarUrl,
          isActive: false, // Will be set based on active profile
        );
        
        profiles.add(profile);
      }
      
      // Set the first profile as active if no active profile is set
      if (profiles.isNotEmpty && getActiveProfileId() == null) {
        await setActiveProfile(profiles.first.id);
      }
      
      // Update the active status
      final activeProfileId = getActiveProfileId();
      for (int i = 0; i < profiles.length; i++) {
        profiles[i] = profiles[i].copyWith(isActive: profiles[i].id == activeProfileId);
      }
      
      // Save to local storage for offline access
      await _saveProfiles(profiles);
      _cachedProfiles = profiles;
      
      return profiles;
    } catch (e) {
      // Fallback to local storage
      final profilesJson = _prefs.getString(_profilesKey);
      if (profilesJson != null) {
        final dynamic decoded = jsonDecode(profilesJson);
        if (decoded is List) {
          final profiles = decoded
              .map((json) => EuProfile.fromJson(json as Map<String, dynamic>))
              .toList();
          _cachedProfiles = profiles;
          return profiles;
        }
      }
      return [];
    }
  }

  @override
  List<EuProfile>? getProfilesSync() {
    return _cachedProfiles;
  }

  @override
  Future<void> addProfile(EuProfile profile) async {
    // Get existing profiles without calling getProfiles() to avoid recursion
    final profilesJson = _prefs.getString(_profilesKey);
    List<EuProfile> profiles = [];
    
    if (profilesJson != null) {
      final dynamic decoded = jsonDecode(profilesJson);
      if (decoded is List) {
        profiles = decoded
            .map((json) => EuProfile.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }
    
    profiles.add(profile);
    await _saveProfiles(profiles);
  }

  @override
  Future<void> updateProfile(EuProfile profile) async {
    // Get existing profiles without calling getProfiles() to avoid recursion
    final profilesJson = _prefs.getString(_profilesKey);
    List<EuProfile> profiles = [];
    
    if (profilesJson != null) {
      final dynamic decoded = jsonDecode(profilesJson);
      if (decoded is List) {
        profiles = decoded
            .map((json) => EuProfile.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }
    
    final index = profiles.indexWhere((p) => p.id == profile.id);
    if (index != -1) {
      profiles[index] = profile;
      await _saveProfiles(profiles);
    }
  }

  @override
  Future<void> deleteProfile(String profileId) async {
    // Get existing profiles without calling getProfiles() to avoid recursion
    final profilesJson = _prefs.getString(_profilesKey);
    List<EuProfile> profiles = [];
    
    if (profilesJson != null) {
      final dynamic decoded = jsonDecode(profilesJson);
      if (decoded is List) {
        profiles = decoded
            .map((json) => EuProfile.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }
    
    profiles.removeWhere((p) => p.id == profileId);
    await _saveProfiles(profiles);
    
    // If this was the active profile, clear the active profile
    if (getActiveProfileId() == profileId) {
      await _prefs.remove(_activeProfileKey);
    }
  }

  @override
  Future<void> setActiveProfile(String profileId) async {
    await _prefs.setString(_activeProfileKey, profileId);
    
    // Update the profiles to mark the correct one as active
    final profilesJson = _prefs.getString(_profilesKey);
    List<EuProfile> profiles = [];
    
    if (profilesJson != null) {
      final dynamic decoded = jsonDecode(profilesJson);
      if (decoded is List) {
        profiles = decoded
            .map((json) => EuProfile.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }
    
    for (int i = 0; i < profiles.length; i++) {
      profiles[i] = profiles[i].copyWith(isActive: profiles[i].id == profileId);
    }
    await _saveProfiles(profiles);
  }

  @override
  String? getActiveProfileId() {
    return _prefs.getString(_activeProfileKey);
  }

  @override
  Stream<List<EuProfile>> onProfilesChanged() {
    return _profilesStreamController.stream;
  }

  Future<void> _saveProfiles(List<EuProfile> profiles) async {
    final profilesJson = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await _prefs.setString(_profilesKey, profilesJson);
    _profilesStreamController.add(profiles);
  }
}
