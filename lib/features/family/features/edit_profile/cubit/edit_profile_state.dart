part of 'edit_profile_cubit.dart';

enum EditProfileStatus { selectingAvatar, editing, edited, error }

class EditProfileState extends Equatable {
  const EditProfileState({
    required this.currentProfilePicture,
    required this.selectedProfilePicture,
    this.status = EditProfileStatus.selectingAvatar,
    this.error = '',
    this.isRewardAchieved = false,
  });

  final EditProfileStatus status;
  final String currentProfilePicture;
  final String selectedProfilePicture;
  final String error;
  final bool isRewardAchieved;

  bool get isSameProfilePicture {
    return currentProfilePicture == selectedProfilePicture;
  }

  @override
  List<Object> get props => [
        status,
        currentProfilePicture,
        selectedProfilePicture,
        error,
        isRewardAchieved,
      ];

  EditProfileState copyWith({
    EditProfileStatus? status,
    String? currentProfilePicture,
    String? selectedProfilePicture,
    String? error,
    bool? isRewardAchieved,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      currentProfilePicture:
          currentProfilePicture ?? this.currentProfilePicture,
      selectedProfilePicture:
          selectedProfilePicture ?? this.selectedProfilePicture,
      error: error ?? this.error,
      isRewardAchieved: isRewardAchieved ?? this.isRewardAchieved,
    );
  }
}
