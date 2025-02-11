class AvatarUIModel {
  AvatarUIModel({
    required this.avatarUrl,
    required this.text,
    this.isSelected = false,
    this.hasDonated = false,
    this.guid,
  });

  final bool isSelected;
  final bool hasDonated;
  final String avatarUrl;
  final String text;
  final String? guid;
}
