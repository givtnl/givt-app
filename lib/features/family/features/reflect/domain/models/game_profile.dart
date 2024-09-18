import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';

class GameProfile {
  const GameProfile({
    required this.type,
    this.firstName,
    this.lastName,
    this.pictureURL,
    this.role,
    this.gratitudeInterests,
  });

  final String? firstName;
  final String? lastName;
  final String? pictureURL;
  final Role? role;
  final String type;
  final List<Tag>? gratitudeInterests;

  ProfileType get profileType => ProfileType.getByTypeName(type);

  bool get isAdult => profileType == ProfileType.Parent;

  bool get isChild => profileType == ProfileType.Child;

  GameProfile copyWith({
    String? firstName,
    String? lastName,
    String? pictureURL,
    Role? role,
    String? type,
    List<Tag>? gratitudeInterests,
  }) {
    return GameProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      pictureURL: pictureURL ?? this.pictureURL,
      role: role ?? this.role,
      type: type ?? this.type,
      gratitudeInterests: gratitudeInterests ?? this.gratitudeInterests,
    );
  }
}
