import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/details/models/profile_ext.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';

mixin ChildDetailsRepository {
  Future<ProfileExt> fetchChildDetails(Profile profile);
}

class ChildDetailsRepositoryImpl with ChildDetailsRepository {
  ChildDetailsRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<ProfileExt> fetchChildDetails(Profile profile) async {
    final response = await apiService.fetchChildDetails(profile.id);
    return ProfileExt.fromMap(profile, response);
  }
}
