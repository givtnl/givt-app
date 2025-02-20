sealed class GratitudeGoalCustom {
  const GratitudeGoalCustom();

  const factory GratitudeGoalCustom.startCountdownTo(DateTime countdownTo) =
      StartCounter;
}

class StartCounter extends GratitudeGoalCustom {
  const StartCounter(this.countdownTo);

  final DateTime countdownTo;
}
