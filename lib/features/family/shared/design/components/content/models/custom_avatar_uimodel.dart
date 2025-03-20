class CustomAvatarUIModel {
  CustomAvatarUIModel({
    this.assetsToOverlap = const [],
    this.semanticsIdentifier = 'defaultCustomAvatar',
  });

  final List<String> assetsToOverlap;
  final String semanticsIdentifier;
}
