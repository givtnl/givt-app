import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/children/edit_profile/models/edit_profile.dart';

mixin EditProfileRepository {
  Future<void> editProfile({required EditProfile editProfile});
}

class EditProfileRepositoryImpl with EditProfileRepository {
  EditProfileRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<void> editProfile({required EditProfile editProfile}) async {
    await _apiService.editProfile(editProfile.toJson());
  }
}
