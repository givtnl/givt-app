import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/overview/models/legacy_profile.dart';

mixin FamilyOverviewRepository {
  Future<List<LegacyProfile>> fetchFamily();
}

class FamilyOverviewRepositoryImpl with FamilyOverviewRepository {
  FamilyOverviewRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<List<LegacyProfile>> fetchFamily() async {
    final response = await apiService.fetchProfiles();

    final result = <LegacyProfile>[];
    for (final profileMap in response) {
      result.add(LegacyProfile.fromMap(profileMap as Map<String, dynamic>));
    }
    return result;
  }
}
