class AvatarUIModel {
  AvatarUIModel({
    required this.avatar,
    required this.text,
    this.isSelected = false,
    this.hasDonated = false,
    this.guid,
  });

  final bool isSelected;
  final bool hasDonated;
  final String avatar;
  final String text;
  final String? guid;
}
