sealed class SummaryDetailsCustom {
  const SummaryDetailsCustom();

  const factory SummaryDetailsCustom.showConfetti() = ShowConfetti;
  const factory SummaryDetailsCustom.navigateToNextScreen() =
      NavigateToNextScreen;
}

class ShowConfetti extends SummaryDetailsCustom {
  const ShowConfetti();
}

class NavigateToNextScreen extends SummaryDetailsCustom {
  const NavigateToNextScreen();
}
