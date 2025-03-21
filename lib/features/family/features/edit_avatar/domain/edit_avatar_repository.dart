import 'dart:async';

import 'package:givt_app/features/family/features/profiles/models/custom_avatar_model.dart';
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

  Future<void> updateCustomAvatar(
    String userId,
    CustomAvatarModel customAvatar,
  ) async {
    await _api.editProfile(userId, {'customAvatar': customAvatar.toJson()});
    _avatarChangedController.add(null);
  }

  Stream<void> onAvatarChanged() => _avatarChangedController.stream;
}
