import 'dart:async';

import 'package:givt_app/features/family/features/edit_child_profile/models/edit_profile.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

mixin EditChildProfileRepository {
  Future<void> editProfile({
    required String childGUID,
    required EditProfile editProfile,
  });

  Stream<String> onChildAvatarChanged();
}

class EditProfileRepositoryImpl with EditChildProfileRepository {
  EditProfileRepositoryImpl(
    this._apiService,
  );

  final FamilyAPIService _apiService;
  final StreamController<String> _childAvatarChangedController =
      StreamController.broadcast();

  @override
  Future<void> editProfile({
    required String childGUID,
    required EditProfile editProfile,
  }) async {
    await _apiService.editProfile(childGUID, editProfile.toJson());
    _childAvatarChangedController.add(childGUID);
  }

  @override
  Stream<String> onChildAvatarChanged() => _childAvatarChangedController.stream;
}
