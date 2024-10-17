import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

sealed class InterviewCustom {
  const InterviewCustom();

  const factory InterviewCustom.goToPassThePhoneToSidekick(
      {required GameProfile profile}) = PassThePhoneToSidekick;

  const factory InterviewCustom.goToGratitudeSelection(
      {required GameProfile reporter}) = GratitudeSelection;
}

class PassThePhoneToSidekick extends InterviewCustom {
  const PassThePhoneToSidekick({
    required this.profile,
  });

  final GameProfile profile;
}

class GratitudeSelection extends InterviewCustom {
  const GratitudeSelection({
    required this.reporter,
  });

  final GameProfile reporter;
}
