import 'dart:async';

import 'package:givt_app/features/family/network/family_api_service.dart';

class EditAvatarRepository {
  EditAvatarRepository(
    this._api,
  );

  final FamilyAPIService _api;

  final StreamController<void> _avatarChangedController =
      StreamController.broadcast();

  Future<void> updateAvatar(
    String userId,
    String image,
  ) async {
    await _api.editProfile(userId, {'ProfilePicture': image});
    _avatarChangedController.add(null);
  }

  Stream<void> onAvatarChanged() => _avatarChangedController.stream;
}
