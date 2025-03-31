/// A class representing the features available in the application.
/// This class is used to define and manage the various features
/// that can be unlocked or utilized within the app.
class Features {
  static const String avatarCustomBody = 'avatar_custom_body';
  static const String avatarCustomHair = 'avatar_custom_hair';
  static const String avatarCustomMask = 'avatar_custom_mask';
  static const String avatarCustomSuit = 'avatar_custom_suit';

  static const String profileEditAvatarButton = 'profile_edit_avatar_button';

  static const String familyHomeProfile = 'family_home_profile';

  static const List<String> tabsOrderOfFeatures = [
    Features.avatarCustomBody,
    Features.avatarCustomHair,
    Features.avatarCustomMask,
    Features.avatarCustomSuit,
  ];

  /// A map that defines the hierarchy of features.
  ///
  /// The keys in the map represent feature names, and the values are lists
  /// of strings that specify the sub-features or dependencies associated
  /// with each feature.
  static Map<String, List<String>> featureHierarchy = {
    Features.avatarCustomBody:
        List.generate(666, (index) => '$avatarCustomBody$index'),
    Features.avatarCustomHair:
        List.generate(666, (index) => '$avatarCustomHair$index'),
    Features.avatarCustomMask:
        List.generate(666, (index) => '$avatarCustomMask$index'),
    Features.avatarCustomSuit:
        List.generate(666, (index) => '$avatarCustomSuit$index'),
    Features.profileEditAvatarButton: [
      Features.avatarCustomBody,
      Features.avatarCustomHair,
      Features.avatarCustomMask,
      Features.avatarCustomSuit,
    ],
    Features.familyHomeProfile: [
      Features.profileEditAvatarButton,
    ],
  };

  static bool isItemFeature(String feature) {
    return feature.contains(avatarCustomBody) ||
        feature.contains(avatarCustomHair) ||
        feature.contains(avatarCustomMask) ||
        feature.contains(avatarCustomSuit);
  }

  static int? extractItemFeatureNumber(String feature) {
    if (feature.contains(avatarCustomBody)) {
      return int.tryParse(feature.substring(avatarCustomBody.length));
    } else if (feature.contains(avatarCustomHair)) {
      return int.tryParse(feature.substring(avatarCustomHair.length));
    } else if (feature.contains(avatarCustomMask)) {
      return int.tryParse(feature.substring(avatarCustomMask.length));
    } else if (feature.contains(avatarCustomSuit)) {
      return int.tryParse(feature.substring(avatarCustomSuit.length));
    }
    return null;
  }
}
