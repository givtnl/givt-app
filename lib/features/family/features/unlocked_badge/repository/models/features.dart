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
  static const Map<String, List<String>> featureHierarchy = {
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
}
