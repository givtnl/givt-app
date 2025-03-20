import 'dart:async';

import 'package:givt_app/features/family/features/edit_avatar/domain/edit_avatar_repository.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_custom.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_uimodel.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/looking_good_uimodel.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/pages/edit_avatar_screen.dart';
import 'package:givt_app/features/family/features/profiles/models/custom_avatar_model.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class EditAvatarCubit extends CommonCubit<EditAvatarUIModel, EditAvatarCustom> {
  EditAvatarCubit(
    this._repository,
    this._profilesRepository,
  ) : super(const BaseState.loading());

  String userGuid = '';
  Profile? _profile;
  String _selectedAvatar = 'Hero1.svg';
  String _customMode = EditAvatarScreen.options.first;
  bool _lockMessageEnabled = false;
  Timer? _lockMessageTimer;
  CustomAvatarModel _customAvatar = CustomAvatarModel.initial();

  final EditAvatarRepository _repository;
  final ProfilesRepository _profilesRepository;

  /// Initialize the cubit
  void init(String userGuid) {
    this.userGuid = userGuid;

    _profilesRepository.getProfiles().then((profiles) {
      _profile = profiles.firstWhere(
        (profile) => profile.id == userGuid,
      );

      if (_profile?.avatar != null) {
        setAvatar(_profile!.avatar!);
      } else if (_profile?.customAvatar != null) {
        _customAvatar = _profile!.customAvatar!;
        _customMode = EditAvatarScreen.options.last;
        _emitData();
      } else {
        _emitData();
      }
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
        avatarName: _selectedAvatar,
        mode: _customMode,
        lockMessageEnabled: _lockMessageEnabled,
        customAvatarUIModel: _customAvatar.toUIModel(),
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
