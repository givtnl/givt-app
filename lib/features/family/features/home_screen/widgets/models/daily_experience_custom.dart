sealed class DailyExperienceCustom {
  const DailyExperienceCustom();

  const factory DailyExperienceCustom.startCountdownTo(DateTime countdownTo) =
      StartCounter;
}

class StartCounter extends DailyExperienceCustom {
  const StartCounter(this.countdownTo);

  final DateTime countdownTo;
}
