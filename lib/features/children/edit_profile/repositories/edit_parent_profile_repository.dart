import 'dart:async';

import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/children/edit_profile/models/edit_profile.dart';

mixin EditParentProfileRepository {
  Future<void> editProfile({required EditProfile editProfile});

  Stream<void> onProfileChanged();
}

class EditParentProfileRepositoryImpl with EditParentProfileRepository {
  EditParentProfileRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;
  final StreamController<void> _profileChangedController =
      StreamController<void>.broadcast();

  @override
  Future<void> editProfile({required EditProfile editProfile}) async {
    await _apiService.editProfile(editProfile.toJson());
    _profileChangedController.add(null);
  }

  @override
  Stream<void> onProfileChanged() => _profileChangedController.stream;
}
