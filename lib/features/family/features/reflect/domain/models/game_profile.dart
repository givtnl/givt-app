import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';

class GameProfile {
  GameProfile({
    required this.type,
    required this.userId,
    this.firstName,
    this.lastName,
    this.pictureURL,
    this.roles = const [],
    this.gratitude,
  });

  final String userId;
  final String? firstName;
  final String? lastName;
  final String? pictureURL;
  final List<Role> roles;
  final String type;
  final GratitudeCategory? gratitude;

  ProfileType get profileType => ProfileType.getByTypeName(type);

  bool get isAdult => profileType == ProfileType.Parent;

  bool get isChild => profileType == ProfileType.Child;

  Role? get role => roles.firstOrNull;

  Reporter? get reporterRole => roles.whereType<Reporter>().firstOrNull;

  Sidekick? get sidekickRole => roles.whereType<Sidekick>().firstOrNull;

  AvatarUIModel toAvatarUIModel({
    bool isSelected = false,
    bool hasDonated = false,
  }) {
    return AvatarUIModel(
      hasDonated: hasDonated,
      isSelected: isSelected,
      avatarUrl: pictureURL!,
      text: firstName!,
    );
  }

  GameProfile copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? pictureURL,
    Role? role,
    List<Role>? roles,
    String? type,
    GratitudeCategory? gratitude,
  }) {
    return GameProfile(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      pictureURL: pictureURL ?? this.pictureURL,
      roles: role != null ? [role] : roles ?? this.roles,
      type: type ?? this.type,
      gratitude: gratitude ?? this.gratitude,
    );
  }
}
