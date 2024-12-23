import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

sealed class GameRolesCustom {
  const GameRolesCustom();

  const factory GameRolesCustom.passThePhone({
    required GameProfile profile,
  }) = GoToPassThePhone;

  const factory GameRolesCustom.passThePhoneAndReplace({
    required GameProfile profile,
  }) = GoToPassThePhoneAndReplace;

  const factory GameRolesCustom.showVolumeBottomsheet() = ShowVolumeBottomsheet;
}

class GoToPassThePhone extends GameRolesCustom {
  const GoToPassThePhone({
    required this.profile,
  });

  final GameProfile profile;
}

class GoToPassThePhoneAndReplace extends GameRolesCustom {
  const GoToPassThePhoneAndReplace({
    required this.profile,
  });

  final GameProfile profile;
}

class ShowVolumeBottomsheet extends GameRolesCustom {
  const ShowVolumeBottomsheet();
}
