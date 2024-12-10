part of 'edit_profile_cubit.dart';

enum EditProfileStatus { selectingAvatar, editing, edited, error }

class EditProfileState extends Equatable {
  const EditProfileState({
    required this.currentProfilePicture,
    required this.selectedProfilePicture,
    this.status = EditProfileStatus.selectingAvatar,
    this.error = '',
  });

  final EditProfileStatus status;
  final String currentProfilePicture;
  final String selectedProfilePicture;
  final String error;

  bool get isSameProfilePicture {
    return currentProfilePicture == selectedProfilePicture;
  }

  @override
  List<Object> get props =>
      [status, currentProfilePicture, selectedProfilePicture, error];

  EditProfileState copyWith({
    EditProfileStatus? status,
    String? currentProfilePicture,
    String? selectedProfilePicture,
    String? error,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      currentProfilePicture:
          currentProfilePicture ?? this.currentProfilePicture,
      selectedProfilePicture:
          selectedProfilePicture ?? this.selectedProfilePicture,
      error: error ?? this.error,
    );
  }
}
