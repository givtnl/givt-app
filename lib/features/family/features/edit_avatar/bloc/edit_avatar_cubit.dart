import 'dart:async';

import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class EditAvatarCubit extends CommonCubit<EditAvatarUIModel, EditAvatarCustom> {
  EditAvatarCubit(
    this._repository,
    this._profilesRepository,
    this._sharedPreferences,
    this._authRepository,
  ) : super(const BaseState.loading());

  String userGuid = '';
  Profile? _profile;
  String _selectedAvatar = 'Hero1.svg';
  String _customMode = EditAvatarScreen.options.first;
  bool _lockMessageEnabled = false;
  Timer? _lockMessageTimer;
  CustomAvatarModel _customAvatar = CustomAvatarModel.initial();
  bool _hasMadeAnyCustomAvatarSelection = false;

  final EditAvatarRepository _repository;
  final ProfilesRepository _profilesRepository;
  final SharedPreferences _sharedPreferences;
  final FamilyAuthRepository _authRepository;

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
      if (isFirstVisitSinceUnlock()) {
        setFirstVisitSinceUnlock();
        _customMode = EditAvatarScreen.options.last;
        _emitData();
      }
    });
  }

  bool isGivtEmployee() {
    return _authRepository.getCurrentUser()?.email.contains('givt') ?? false;
  }

  bool isFirstVisitSinceUnlock() {
    final isFirstVisit = !_sharedPreferences
        .containsKey('edit_avatar_first_visit_${_profile?.id}');
    return isFirstVisit;
  }

  void setFirstVisitSinceUnlock() {
    _sharedPreferences.setBool(
      'edit_avatar_first_visit_${_profile?.id}',
      true,
    );
  }

  @override
  Future<void> close() {
    _lockMessageTimer?.cancel();
    return super.close();
  }

  /// Save the selected avatar
  void saveAvatar() {
    emitLoading();

    if (_isInCustomAvatarMode) {
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
          avatar: _isInCustomAvatarMode ? null : _selectedAvatar,
          customAvatarUIModel:
              _isInCustomAvatarMode ? _customAvatar.toUIModel() : null,
          userFirstName: _profile!.firstName,
        ),
      ),
    );
  }

  bool get _isInCustomAvatarMode =>
      _customMode == EditAvatarScreen.options.last;

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
    return _profile?.unlocks.contains('avatar_custom') ?? false;
  }

  List<EditAvatarItemUIModel> bodyItems() {
    return List.generate(
      12,
      (index) => UnlockedItem(
        type: 'Body',
        index: index + 1,
        isSelected: index + 1 == _customAvatar.bodyIndex,
      ),
    );
  }

  List<EditAvatarItemUIModel> hairItems() {
    final list = List.generate(
      3,
      (index) => UnlockedItem(
        type: 'Hair',
        index: index,
        isSelected: index == _customAvatar.hairIndex,
      ),
    );
    if (isGivtEmployee()) {
      list.addAll([
        UnlockedItem(
          type: 'Hair',
          index: 666,
          isSelected: 666 == _customAvatar.hairIndex,
        )
      ]);
    }
    return list;
  }

  List<EditAvatarItemUIModel> maskItems() {
    final list = List.generate(
      3,
      (index) => UnlockedItem(
        type: 'Mask',
        index: index,
        isSelected: index == _customAvatar.maskIndex,
      ),
    );

    if (isGivtEmployee()) {
      list.addAll([
        UnlockedItem(
          type: 'Mask',
          index: 666,
          isSelected: 666 == _customAvatar.maskIndex,
        ),
        UnlockedItem(
          type: 'Mask',
          index: 667,
          isSelected: 667 == _customAvatar.maskIndex,
        ),
        UnlockedItem(
          type: 'Mask',
          index: 668,
          isSelected: 668 == _customAvatar.maskIndex,
        ),
        UnlockedItem(
          type: 'Mask',
          index: 669,
          isSelected: 669 == _customAvatar.maskIndex,
        ),
        UnlockedItem(
          type: 'Mask',
          index: 670,
          isSelected: 670 == _customAvatar.maskIndex,
        ),
      ]);
    }
    return list;
  }

  List<EditAvatarItemUIModel> suitItems() {
    final list = List.generate(
      2,
      (index) => UnlockedItem(
        type: 'Suit',
        index: index + 1,
        isSelected: index + 1 == _customAvatar.suitIndex,
      ),
    );

    if (isGivtEmployee()) {
      list.addAll([
        UnlockedItem(
          type: 'Suit',
          index: 666,
          isSelected: 666 == _customAvatar.suitIndex,
        ),
        UnlockedItem(
          type: 'Suit',
          index: 667,
          isSelected: 667 == _customAvatar.suitIndex,
        ),
      ]);
    }
    return list;
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
    if ((_defaultAvatarHasntChanged() && _customAvatarHasntChanged()) ||
        force) {
      emitCustom(const EditAvatarCustom.navigateToProfile());
      return Future.value();
    }

    emitCustom(const EditAvatarCustom.showSaveOnBackDialog());
    return Future.value();
  }

  bool _customAvatarHasntChanged() =>
      !isFeatureUnlocked() ||
      !_hasMadeAnyCustomAvatarSelection ||
      _customAvatar == _profile!.customAvatar;

  bool _defaultAvatarHasntChanged() => _selectedAvatar == _profile!.avatar;

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
    _hasMadeAnyCustomAvatarSelection = true;
    switch (type) {
      case 'Body':
        _customAvatar = _customAvatar.copyWith(bodyIndex: index);
        break;
      case 'Hair':
        _customAvatar = _customAvatar.copyWith(hairIndex: index);
        break;
      case 'Mask':
        _customAvatar = _customAvatar.copyWith(maskIndex: index);
        break;
      case 'Suit':
        _customAvatar = _customAvatar.copyWith(suitIndex: index);
        break;
    }
    _emitData();
  }
}
