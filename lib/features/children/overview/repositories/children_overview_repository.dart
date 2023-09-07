import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';

mixin ChildrenOverviewRepository {
  Future<List<Profile>> fetchChildren(String parentGuid);
}

class ChildrenOverviewRepositoryImpl with ChildrenOverviewRepository {
  ChildrenOverviewRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<List<Profile>> fetchChildren(String parentGuid) async {
    final response = await apiService.fetchChildren(parentGuid);

    final result = <Profile>[];
    for (final profileMap in response) {
      result.add(Profile.fromMap(profileMap as Map<String, dynamic>));
    }
    return result;
  }
}
