import 'dart:async';
import 'dart:ui';

import 'package:givt_app/core/enums/amplitude_events.dart';
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
import 'package:givt_app/features/family/features/unlocked_badge/repository/models/features.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/unlocked_badge_repository.dart';
import 'package:givt_app/features/family/helpers/helpers.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAvatarCubit extends CommonCubit<EditAvatarUIModel, EditAvatarCustom> {
  EditAvatarCubit(
    this._repository,
    this._profilesRepository,
    this._sharedPreferences,
    this._authRepository,
    this._unlockBadgeRepository,
  ) : super(const BaseState.loading());

  String userGuid = '';
  Profile? _profile;
  String _selectedAvatar = 'Hero1.svg';
  String _customMode = EditAvatarScreen.options.first;
  bool _lockMessageEnabled = false;
  Timer? _lockMessageTimer;
  CustomAvatarModel _customAvatar = CustomAvatarModel.initial();
  bool _hasMadeAnyCustomAvatarSelection = false;
  bool _isProd = true;

  final EditAvatarRepository _repository;
  final ProfilesRepository _profilesRepository;
  final SharedPreferences _sharedPreferences;
  final FamilyAuthRepository _authRepository;
  final UnlockedBadgeRepository _unlockBadgeRepository;

  /// Initialize the cubit
  Future<void> init(String userGuid) async {
    this.userGuid = userGuid;
    _isProd = !(await isDebugApp());
    await _profilesRepository.getProfiles().then((profiles) {
      _profile = profiles.firstWhere(
        (profile) => profile.id == userGuid,
      );

      if (_profile?.avatar != null) {
        setAvatar(_profile!.avatar!);
      } else if (_profile?.customAvatar != null) {
        _customAvatar = _profile!.customAvatar!;
        manualUnlockBadge(Features.tabsOrderOfFeatures[0]);
        _customMode = EditAvatarScreen.options.last;
        _emitData();
      } else {
        _emitData();
      }
      if (isFirstVisitSinceUnlock()) {
        setFirstVisitSinceUnlock();
        _customMode = EditAvatarScreen.options.last;
        manualUnlockBadge(Features.tabsOrderOfFeatures[0]);
        _emitData();
        if (_isProd && _isSjoerd) {
          _customAvatar = CustomAvatarModel.initialSjoerd();
          _emitData();
        }
        if (_isProd && _isTine) {
          _customAvatar = CustomAvatarModel.initialTine();
          _emitData();
        }
      }
    });
  }

  Future<bool> isDebugApp() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.packageName.contains('test');
    } catch (e) {
      return false;
    }
  }

  bool get _isSjoerd => _profile?.id == '7a5d09d4-ab32-45ef-9c77-d156d7e71a0d';

  bool get _isTine => _profile?.id == '1c1bd573-bfa0-4d32-93c1-6e173d0fac58';

  bool isGivtEmployee() {
    return _authRepository.getCurrentUser()?.email.contains('@givt') ?? false;
  }

  bool shouldShowEasterEgg() =>
      _isProd && (isGivtEmployee() || _isSjoerd || _isTine);

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
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.customAvatarSaved,
        eventProperties: _customAvatar.toJson(),
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
          possessiveFirstName: _profile!.possessiveName,
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
    final list = List<EditAvatarItemUIModel>.generate(
      3,
      (index) => UnlockedItem(
        type: 'Hair',
        index: index,
        isSelected: index == _customAvatar.hairIndex,
      ),
    );
    if (shouldShowEasterEgg()) {
      list.addAll([
        UnlockedItem(
          type: 'Hair',
          index: 666,
          isSelected: 666 == _customAvatar.hairIndex,
          isEasterEgg: true,
        )
      ]);
    }

    // Add locked items
    list.addAll(List.generate(
      3,
      (index) => const LockedItem(),
    ));

    return list;
  }

  List<EditAvatarItemUIModel> maskItems() {
    final list = List<EditAvatarItemUIModel>.generate(
      3,
      (index) => UnlockedItem(
        type: 'Mask',
        index: index,
        isSelected: index == _customAvatar.maskIndex,
      ),
    );

    if (shouldShowEasterEgg()) {
      list.addAll(List.generate(
        5,
        (index) => UnlockedItem(
          type: 'Mask',
          index: 666 + index,
          isSelected: 666 + index == _customAvatar.maskIndex,
          isEasterEgg: true,
        ),
      ));
    }

    // Add locked items
    list.addAll(List.generate(
      3,
      (index) => const LockedItem(),
    ));

    return list;
  }

  List<EditAvatarItemUIModel> suitItems() {
    final list = List<EditAvatarItemUIModel>.generate(
      2,
      (index) => UnlockedItem(
        type: 'Suit',
        index: index + 1,
        isSelected: index + 1 == _customAvatar.suitIndex,
      ),
    );

    if (shouldShowEasterEgg()) {
      list.addAll(List.generate(
        2,
        (index) => UnlockedItem(
          type: 'Suit',
          index: 666 + index,
          isSelected: 666 + index == _customAvatar.suitIndex,
          isEasterEgg: true,
        ),
      ));
    }

    // Add locked items
    list.addAll(List.generate(
      4,
      (index) => const LockedItem(),
    ));

    return list;
  }

  void _emitData() {
    emitData(
      EditAvatarUIModel(
        userId: userGuid,
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
    if ((_customMode == EditAvatarScreen.options.first &&
            _defaultAvatarHasntChanged()) ||
        (_customMode == EditAvatarScreen.options.last &&
            _customAvatarHasntChanged()) ||
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

  void setMode(int index) {
    _customMode = EditAvatarScreen.options[index];
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

  void onColorChanged(String type, String? color) {
    _hasMadeAnyCustomAvatarSelection = true;
    switch (type) {
      case 'Hair':
        _customAvatar = _customAvatar.copyWith(hairColor: color);
      case 'Mask':
        _customAvatar = _customAvatar.copyWith(maskColor: color);
      case 'Suit':
        _customAvatar = _customAvatar.copyWith(suitColor: color);
    }

    _emitData();
  }

  void onUnlockedItemClicked(int index, String type, {Color? color}) {
    _hasMadeAnyCustomAvatarSelection = true;
    switch (type) {
      case 'Body':
        _customAvatar = _customAvatar.copyWith(bodyIndex: index);
      case 'Hair':
        _customAvatar = _customAvatar.copyWith(hairIndex: index);
      case 'Mask':
        _customAvatar = _customAvatar.copyWith(maskIndex: index);
      case 'Suit':
        _customAvatar = _customAvatar.copyWith(suitIndex: index);
      case 'HairColor':
        if (color != null) {
          _customAvatar = _customAvatar.copyWith(hairColor: colorToHex(color));
        }
    }

    _emitData();
  }

  void manualUnlockBadge(String featureId) {
    if (_unlockBadgeRepository.isFeatureSeen(userGuid, featureId)) {
      return;
    }
    _unlockBadgeRepository.markFeatureAsSeen(userGuid, featureId);
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.newBadgeSeen,
      eventProperties: {
        'featureId': featureId,
      },
    );
  }
}
