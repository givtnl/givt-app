import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';

mixin FamilyOverviewRepository {
  Future<List<Profile>> fetchFamily();
}

class FamilyOverviewRepositoryImpl with FamilyOverviewRepository {
  FamilyOverviewRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<List<Profile>> fetchFamily() async {
    final response = await apiService.fetchProfiles();

    final result = <Profile>[];
    for (final profileMap in response) {
      result.add(Profile.fromMap(profileMap as Map<String, dynamic>));
    }
    return result;
  }
}
