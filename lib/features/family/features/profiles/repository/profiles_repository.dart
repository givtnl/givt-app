import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/network/api_service.dart';

mixin ProfilesRepository {
  Future<Profile> fetchChildDetails(String childGuid);
  Future<List<Profile>> fetchAllProfiles();
}

class ProfilesRepositoryImpl with ProfilesRepository {
  ProfilesRepositoryImpl(
    this._apiService,
  );

  final FamilyAPIService _apiService;

  @override
  Future<List<Profile>> fetchAllProfiles() async {
    final response = await _apiService.fetchAllProfiles();
    final result = <Profile>[];
    for (final profileMap in response ?? []) {
      result.add(Profile.fromMap(profileMap as Map<String, dynamic>));
    }
    return result;
  }

  @override
  Future<Profile> fetchChildDetails(String childGuid) async {
    final response = await _apiService.fetchChildDetails(childGuid);
    return Profile.fromMap(response);
  }
}
