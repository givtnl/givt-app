import 'package:givt_app/features/family/features/edit_profile/models/edit_profile.dart';
import 'package:givt_app/features/family/network/api_service.dart';

mixin EditProfileRepository {
  Future<void> editProfile({
    required String childGUID,
    required EditProfile editProfile,
  });
}

class EditProfileRepositoryImpl with EditProfileRepository {
  EditProfileRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<void> editProfile({
    required String childGUID,
    required EditProfile editProfile,
  }) async {
    await _apiService.editProfile(childGUID, editProfile.toJson());
  }
}
