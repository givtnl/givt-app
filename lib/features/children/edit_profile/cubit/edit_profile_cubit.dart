import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/edit_profile/models/edit_profile.dart';
import 'package:givt_app/features/children/edit_profile/repositories/edit_parent_profile_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({
    required this.editProfileRepository,
    required String currentProfilePicture,
  }) : super(
          EditProfileState(
            currentProfilePicture:
                _extractFileNameFromPictureUrl(currentProfilePicture),
            selectedProfilePicture:
                _extractFileNameFromPictureUrl(currentProfilePicture),
          ),
        );

  final EditParentProfileRepository editProfileRepository;

  static String _extractFileNameFromPictureUrl(String url) {
    if (url.isEmpty) {
      return '';
    }
    final file = File(url);
    return basename(file.path);
  }

  void selectProfilePicture(String profilePicture) {
    emit(
      state.copyWith(
        selectedProfilePicture: profilePicture,
        status: EditProfileStatus.selectingAvatar,
        error: '',
      ),
    );
  }

  Future<void> editProfile() async {
    emit(state.copyWith(status: EditProfileStatus.editing));

    try {
      await editProfileRepository.editProfile(
        editProfile: EditProfile(profilePicture: state.selectedProfilePicture),
      );

      emit(state.copyWith(status: EditProfileStatus.edited));
    } catch (e) {
      emit(
        state.copyWith(status: EditProfileStatus.error, error: e.toString()),
      );
    }
  }
}
