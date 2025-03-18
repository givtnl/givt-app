import 'dart:async';

import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/edit_avatar/domain/edit_avatar_repository.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_custom.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_uimodel.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/looking_good_uimodel.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/utils/utils.dart';

class EditAvatarCubit extends CommonCubit<EditAvatarUIModel, EditAvatarCustom> {
  EditAvatarCubit(
    this._repository,
    this._profilesRepository,
  ) : super(const BaseState.loading());

  String userGuid = '';
  Profile? _profile;
  String _selectedAvatar = '';
  String _customMode = 'Default';
  bool _lockMessageEnabled = false;
  Timer? _lockMessageTimer;

  final EditAvatarRepository _repository;
  final ProfilesRepository _profilesRepository;

  /// Initialize the cubit
  void init(String userGuid) {
    this.userGuid = userGuid;

    _profilesRepository.getProfiles().then((profiles) {
      _profile = profiles.firstWhere(
        (profile) => profile.id == userGuid,
      );

      setAvatar(_profile!.avatar);
    });
  }

  @override
  Future<void> close() {
    _lockMessageTimer?.cancel();
    return super.close();
  }

  /// Save the selected avatar
  void saveAvatar() {
    emitLoading();

    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.saveAvatarClicked,
    );

    _repository.updateAvatar(
      userGuid,
      _selectedAvatar, // Use the selected avatar
    );

    emitCustom(
      EditAvatarCustom.navigateToLookingGoodScreen(
        LookingGoodUIModel(
          avatar: _selectedAvatar,
          userFirstName: _profile!.firstName,
        ),
      ),
    );
  }

  /// Set the avatar to the selected avatar
  void setAvatar(String avatarName) {
    _selectedAvatar = avatarName;
    _emitData();
  }

  void _emitData() {
    emitData(
      EditAvatarUIModel(
        _selectedAvatar,
        _customMode,
        _lockMessageEnabled,
      ),
    );
  }

  Future<void> navigateBack({bool force = false}) {
    if (_selectedAvatar == _profile!.avatar || force) {
      emitCustom(const EditAvatarCustom.navigateToProfile());
      return Future.value();
    }

    emitCustom(const EditAvatarCustom.showSaveOnBackDialog());
    return Future.value();
  }

  void setMode(Set<String> option) {
    _customMode = option.first;
    _emitData();
  }

  void lockedButtonClicked() {
    _lockMessageEnabled = true;
    _emitData();

    _lockMessageTimer?.cancel(); // Cancel any existing timer
    _lockMessageTimer = Timer(const Duration(milliseconds: 6000), () {
      _lockMessageEnabled = false;
      _emitData();
    });
  }
}
