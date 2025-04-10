class CustomAvatarUIModel {
  CustomAvatarUIModel({
    this.assetsToOverlap = const [],
    this.semanticsIdentifier = 'defaultCustomAvatar',
    this.hairColor,
    this.maskColor,
    this.suitColor,
  });

  final List<String> assetsToOverlap;
  final String semanticsIdentifier;
  final String? hairColor;
  final String? maskColor;
  final String? suitColor;
}
