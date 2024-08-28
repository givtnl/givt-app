
import 'dart:ui';

import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';

class GameProfile {

  const GameProfile({
    this.firstName,
    this.lastName,
    this.pictureURL,
    this.role,
    this.color,
  });

  final String? firstName;
  final String? lastName;
  final String? pictureURL;
  final Role? role;
  final Color? color;

}