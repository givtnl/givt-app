class AvatarUIModel {
  AvatarUIModel({
    required this.avatarUrl,
    required this.text,
    this.isSelected = false,
    this.hasDonated = false,
  });

  final bool isSelected;
  final bool hasDonated;
  final String avatarUrl;
  final String text;
}
