import 'dart:async';

import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/family/features/edit_parent_profile/models/edit_parent_profile.dart';

mixin EditParentProfileRepository {
  Future<void> editProfile({required EditParentProfile editProfile});

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
  Future<void> editProfile({required EditParentProfile editProfile}) async {
    await _apiService.editProfile(editProfile.toJson());
    _profileChangedController.add(null);
  }

  @override
  Stream<void> onProfileChanged() => _profileChangedController.stream;
}
