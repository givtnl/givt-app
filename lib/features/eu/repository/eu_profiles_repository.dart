import 'dart:async';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/eu/models/eu_profile.dart';
import 'package:givt_app/shared/models/user_ext.dart';

abstract class EuProfilesRepository {
  Future<List<EuProfile>> getProfiles();
  Future<void> addProfile(UserExt userExt);
  Future<void> removeProfile(String profileId);
  Future<void> setActiveProfile(String profileId);
  Future<EuProfile?> getActiveProfile();
  Stream<List<EuProfile>> onProfilesChanged();
  Future<void> clearProfiles();
}

class EuProfilesRepositoryImpl implements EuProfilesRepository {
  EuProfilesRepositoryImpl(this._authRepository);

  final AuthRepository _authRepository;
  final List<EuProfile> _profiles = [];
  final StreamController<List<EuProfile>> _profilesStreamController = 
      StreamController<List<EuProfile>>.broadcast();

  @override
  Future<List<EuProfile>> getProfiles() async {
    // For now, we'll simulate multiple profiles by creating them from the current user
    // In a real implementation, this would fetch from a backend or local storage
    final currentUser = await _getCurrentUser();
    if (currentUser != null) {
      // Create a profile from the current user
      final currentProfile = EuProfile.fromUserExt(currentUser, isActive: true);
      
      // For demo purposes, create a few additional profiles
      // In real implementation, these would come from backend
      final profiles = <EuProfile>[
        currentProfile,
        // Add some mock profiles for demonstration
        EuProfile(
          id: 'profile2',
          email: 'john.doe@example.com',
          firstName: 'John',
          lastName: 'Doe',
          profilePicture: '',
          isActive: false,
          userExt: UserExt.empty().copyWith(
            guid: 'profile2',
            email: 'john.doe@example.com',
            firstName: 'John',
            lastName: 'Doe',
          ),
        ),
        EuProfile(
          id: 'profile3',
          email: 'jane.smith@example.com',
          firstName: 'Jane',
          lastName: 'Smith',
          profilePicture: '',
          isActive: false,
          userExt: UserExt.empty().copyWith(
            guid: 'profile3',
            email: 'jane.smith@example.com',
            firstName: 'Jane',
            lastName: 'Smith',
          ),
        ),
      ];
      
      _profiles.clear();
      _profiles.addAll(profiles);
      _profilesStreamController.add(_profiles);
      return _profiles;
    }
    
    return [];
  }

  @override
  Future<void> addProfile(UserExt userExt) async {
    final profile = EuProfile.fromUserExt(userExt);
    _profiles.add(profile);
    _profilesStreamController.add(_profiles);
  }

  @override
  Future<void> removeProfile(String profileId) async {
    _profiles.removeWhere((profile) => profile.id == profileId);
    _profilesStreamController.add(_profiles);
  }

  @override
  Future<void> setActiveProfile(String profileId) async {
    for (int i = 0; i < _profiles.length; i++) {
      _profiles[i] = _profiles[i].copyWith(isActive: _profiles[i].id == profileId);
    }
    _profilesStreamController.add(_profiles);
  }

  @override
  Future<EuProfile?> getActiveProfile() async {
    try {
      return _profiles.firstWhere((profile) => profile.isActive);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<List<EuProfile>> onProfilesChanged() => _profilesStreamController.stream;

  @override
  Future<void> clearProfiles() async {
    _profiles.clear();
    _profilesStreamController.add(_profiles);
  }

  Future<UserExt?> _getCurrentUser() async {
    try {
      final result = await _authRepository.isAuthenticated();
      return result?.$1; // Return the UserExt from the tuple
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _profilesStreamController.close();
  }
}