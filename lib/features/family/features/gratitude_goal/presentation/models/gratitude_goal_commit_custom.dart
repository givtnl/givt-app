sealed class GratitudeGoalCommitCustom {
  const GratitudeGoalCommitCustom();

  const factory GratitudeGoalCommitCustom.setButtonLoading(
      {required bool isLoading}) = SetButtonLoading;

  const factory GratitudeGoalCommitCustom.navigateToHome() = NavigateToHome;
}

class SetButtonLoading extends GratitudeGoalCommitCustom {
  const SetButtonLoading({required this.isLoading});

  final bool isLoading;
}

class NavigateToHome extends GratitudeGoalCommitCustom {
  const NavigateToHome();
}