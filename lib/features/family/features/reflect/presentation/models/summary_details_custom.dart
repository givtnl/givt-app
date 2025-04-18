
sealed class SummaryDetailsCustom {
  const SummaryDetailsCustom();

  const factory SummaryDetailsCustom.showConfetti() = ShowConfetti;

  const factory SummaryDetailsCustom.navigateToInGameLeague() =
      NavigateToInGameLeague;

  const factory SummaryDetailsCustom.navigateToGoalProgressUpdate() =
      NavigateToGoalProgressUpdate;
}

class ShowConfetti extends SummaryDetailsCustom {
  const ShowConfetti();
}

class NavigateToInGameLeague extends SummaryDetailsCustom {
  const NavigateToInGameLeague();
}

class NavigateToGoalProgressUpdate extends SummaryDetailsCustom {
  const NavigateToGoalProgressUpdate();
}
