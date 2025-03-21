import 'dart:async';

import 'package:givt_app/features/family/features/edit_avatar/domain/edit_avatar_repository.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_custom.dart';
import 'package:givt_app/features/family/features/edit_avatar/presentation/models/edit_avatar_item_uimodel.dart';
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

  int _selectedBodyIndex = 1;
  int _selectedHairIndex = 0;
  int _selectedMaskIndex = 0;
  int _selectedSuitIndex = 1;

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
        _selectedBodyIndex = _customAvatar.bodyIndex;
        _selectedHairIndex = _customAvatar.hairIndex;
        _selectedMaskIndex = _customAvatar.maskIndex;
        _selectedSuitIndex = _customAvatar.suitIndex;
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

    if (_customMode == EditAvatarScreen.options.last) {
      _repository.updateCustomAvatar(
        userGuid,
        _customAvatar,
      );
    } else {
      _repository.updateAvatar(
        userGuid,
        _selectedAvatar, // Use the selected avatar
      );
    }

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

  List<EditAvatarItemUIModel> everythingLocked() {
    return const [
      LockedItem(),
      LockedItem(),
      LockedItem(),
      LockedItem(),
      LockedItem(),
      LockedItem(),
    ];
  }

  bool isFeatureUnlocked() {
    return _profile?.unlocks.contains('avatar_custom') == true;
  }

  List<EditAvatarItemUIModel> bodyItems() {
    return List.generate(
      12,
      (index) => UnlockedItem(
        type: 'Body',
        index: index + 1,
        isSelected: index + 1 == _selectedBodyIndex,
      ),
    );
  }

  List<EditAvatarItemUIModel> hairItems() {
    return List.generate(
      3,
      (index) => UnlockedItem(
        type: 'Hair',
        index: index,
        isSelected: index == _selectedHairIndex,
      ),
    );
  }

  List<EditAvatarItemUIModel> maskItems() {
    return List.generate(
      3,
      (index) => UnlockedItem(
        type: 'Mask',
        index: index,
        isSelected: index == _selectedMaskIndex,
      ),
    );
  }

  List<EditAvatarItemUIModel> suitItems() {
    return List.generate(
      2,
      (index) => UnlockedItem(
        type: 'Suit',
        index: index + 1,
        isSelected: index + 1 == _selectedSuitIndex,
      ),
    );
  }

  void _emitData() {
    emitData(
      EditAvatarUIModel(
        avatarName: _selectedAvatar,
        mode: _customMode,
        lockMessageEnabled: _lockMessageEnabled,
        isFeatureUnlocked: isFeatureUnlocked(),
        customAvatarUIModel: _customAvatar.toUIModel(),
        bodyItems: isFeatureUnlocked() ? bodyItems() : everythingLocked(),
        hairItems: isFeatureUnlocked() ? hairItems() : everythingLocked(),
        maskItems: isFeatureUnlocked() ? maskItems() : everythingLocked(),
        suitItems: isFeatureUnlocked() ? suitItems() : everythingLocked(),
      ),
    );
  }

  Future<void> navigateBack({bool force = false}) {
    if ((_selectedAvatar == _profile!.avatar &&
            _customAvatar == _profile!.customAvatar) ||
        force) {
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

  void onUnlockedItemClicked(int index, String type) {
    switch (type) {
      case 'Body':
        _selectedBodyIndex = index;
        _customAvatar = _customAvatar.copyWith(bodyIndex: index);
        break;
      case 'Hair':
        _selectedHairIndex = index;
        _customAvatar = _customAvatar.copyWith(hairIndex: index);
        break;
      case 'Mask':
        _selectedMaskIndex = index;
        _customAvatar = _customAvatar.copyWith(maskIndex: index);
        break;
      case 'Suit':
        _selectedSuitIndex = index;
        _customAvatar = _customAvatar.copyWith(suitIndex: index);
        break;
    }
    _emitData();
  }
}
