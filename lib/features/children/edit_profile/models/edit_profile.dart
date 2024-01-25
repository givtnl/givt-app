class EditProfile {
  const EditProfile({
    required this.profilePicture,
  });

  final String profilePicture;

  Map<String, dynamic> toJson() {
    return {
      'profilePicture': profilePicture,
    };
  }
}
