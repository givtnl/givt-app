import 'package:givt_app/features/family/features/profiles/models/custom_avatar_model.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';
import 'package:givt_app/utils/profile_type.dart';

class GameProfile {
  GameProfile({
    required this.type,
    required this.userId,
    this.firstName,
    this.lastName,
    this.avatar,
    this.roles = const [],
    this.gratitude,
    this.power,
    this.customAvatar,
  });

  final String userId;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final List<Role> roles;
  final String type;
  final TagCategory? gratitude;
  final TagCategory? power;
  final CustomAvatarModel? customAvatar;

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
      avatar: avatar,
      text: firstName!,
      customAvatarUIModel: customAvatar?.toUIModel(),
    );
  }

  GameProfile copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? avatar,
    Role? role,
    List<Role>? roles,
    String? type,
    TagCategory? gratitude,
    TagCategory? power,
    CustomAvatarModel? customAvatar,
  }) {
    return GameProfile(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      roles: role != null ? [role] : roles ?? this.roles,
      type: type ?? this.type,
      gratitude: gratitude ?? this.gratitude,
      power: power ?? this.power,
      customAvatar: customAvatar ?? this.customAvatar,
    );
  }
}
