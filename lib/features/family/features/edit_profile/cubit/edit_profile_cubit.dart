import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/features/edit_profile/models/edit_profile.dart';
import 'package:givt_app/features/family/features/edit_profile/repositories/edit_profile_repository.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'edit_profile_state.dart';

class EditChildProfileCubit extends Cubit<EditChildProfileState> {
  EditChildProfileCubit({
    required this.editProfileRepository,
    required this.childGUID,
    required String currentProfilePicture,
  }) : super(
          EditChildProfileState(
            currentProfilePicture:
                _extractFileNameFromPictureUrl(currentProfilePicture),
            selectedProfilePicture:
                _extractFileNameFromPictureUrl(currentProfilePicture),
          ),
        );

  final EditProfileRepository editProfileRepository;
  final String childGUID;

  static String _extractFileNameFromPictureUrl(String url) {
    if (url.isEmpty) {
      return '';
    }
    final file = File(url);
    return basename(file.path);
  }

  static const String _rewardKeyPrefix = 'reward_';

  String get _rewardKey {
    return '$_rewardKeyPrefix$childGUID';
  }

  bool get _isRewardAlreadyAchieved {
    return getIt<SharedPreferences>().getBool(_rewardKey) == true;
  }

  set _saveRewardAchieved(bool value) {
    getIt<SharedPreferences>().setBool(_rewardKey, value);
  }

  void selectProfilePicture(String profilePicture) {
    emit(
      state.copyWith(
        selectedProfilePicture: profilePicture,
        status: EditChildProfileStatus.selectingAvatar,
        error: '',
      ),
    );
  }

  Future<void> editProfile() async {
    emit(state.copyWith(status: EditChildProfileStatus.editing));

    try {
      final firstAvatarChange = !_isRewardAlreadyAchieved;

      await editProfileRepository.editProfile(
        childGUID: childGUID,
        editProfile: EditProfile(
          profilePicture: state.selectedProfilePicture,
          rewardAchieved: firstAvatarChange,
        ),
      );
      if (firstAvatarChange) {
        _saveRewardAchieved = true;
      }

      emit(
        state.copyWith(
          status: EditChildProfileStatus.edited,
          isRewardAchieved: firstAvatarChange,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: EditChildProfileStatus.error, error: e.toString()),
      );
    }
  }
}
