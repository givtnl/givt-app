import 'dart:ui';

import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';

class GameProfile {
  const GameProfile({
    this.firstName,
    this.lastName,
    this.pictureURL,
    this.role,
  });

  final String? firstName;
  final String? lastName;
  final String? pictureURL;
  final Role? role;

  GameProfile copyWith({
    String? firstName,
    String? lastName,
    String? pictureURL,
    Role? role,
  }) {
    return GameProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      pictureURL: pictureURL ?? this.pictureURL,
      role: role ?? this.role,
    );
  }
}
