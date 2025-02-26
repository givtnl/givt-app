import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

sealed class InterviewCustom {
  const InterviewCustom();

  const factory InterviewCustom.goToPassThePhoneToSidekick(
      {required GameProfile profile}) = PassThePhoneToSidekick;

  const factory InterviewCustom.goToGratitudeSelection(
      {required GameProfile reporter}) = GratitudeSelection;

  const factory InterviewCustom.resetTimer() = ResetTimer;

  const factory InterviewCustom.record() = StartRecording;
}

class ResetTimer extends InterviewCustom {
  const ResetTimer();
}

class StartRecording extends InterviewCustom {
  const StartRecording();
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
