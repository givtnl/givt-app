part of 'edit_profile_cubit.dart';

enum EditChildProfileStatus { selectingAvatar, editing, edited, error }

class EditChildProfileState extends Equatable {
  const EditChildProfileState({
    required this.currentProfilePicture,
    required this.selectedProfilePicture,
    this.status = EditChildProfileStatus.selectingAvatar,
    this.error = '',
    this.isRewardAchieved = false,
  });

  final EditChildProfileStatus status;
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

  EditChildProfileState copyWith({
    EditChildProfileStatus? status,
    String? currentProfilePicture,
    String? selectedProfilePicture,
    String? error,
    bool? isRewardAchieved,
  }) {
    return EditChildProfileState(
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
