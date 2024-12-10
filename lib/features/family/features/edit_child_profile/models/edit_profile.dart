class EditProfile {
  const EditProfile({
    this.profilePicture,
    this.rewardAchieved,
  });

  final String? profilePicture;
  final bool? rewardAchieved;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if ((profilePicture ?? '').isNotEmpty) {
      result['profilePicture'] = profilePicture;
    }
    if (true == rewardAchieved) {
      result['rewardAchieved'] = true;
    }
    return result;
  }
}
