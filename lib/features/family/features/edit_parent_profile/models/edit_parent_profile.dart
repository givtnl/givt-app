class EditParentProfile {
  const EditParentProfile({
    required this.profilePicture,
  });

  final String profilePicture;

  Map<String, dynamic> toJson() {
    return {
      'profilePicture': profilePicture,
    };
  }
}
