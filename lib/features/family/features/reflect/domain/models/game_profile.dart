import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';

class GameProfile {
  GameProfile({
    required this.type,
    required this.userId,
    this.firstName,
    this.lastName,
    this.pictureURL,
    this.role,
    this.gratitude,
  });
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? pictureURL;
  final Role? role;
  final String type;
  final GratitudeCategory? gratitude;

  ProfileType get profileType => ProfileType.getByTypeName(type);

  bool get isAdult => profileType == ProfileType.Parent;

  bool get isChild => profileType == ProfileType.Child;

  GameProfile copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? pictureURL,
    Role? role,
    String? type,
    GratitudeCategory? gratitude,
  }) {
    return GameProfile(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      pictureURL: pictureURL ?? this.pictureURL,
      role: role ?? this.role,
      type: type ?? this.type,
      gratitude: gratitude ?? this.gratitude,
    );
  }
}
