sealed class GenerosityChallengeVpcSetupCustom {
  const GenerosityChallengeVpcSetupCustom();

  const factory GenerosityChallengeVpcSetupCustom.navigateToFamilyOverview() =
      NavigateToFamilyOverview;

  const factory GenerosityChallengeVpcSetupCustom.navigateToWelcome() =
      NavigateToWelcome;
}

class NavigateToFamilyOverview extends GenerosityChallengeVpcSetupCustom {
  const NavigateToFamilyOverview();
}

class NavigateToWelcome extends GenerosityChallengeVpcSetupCustom {
  const NavigateToWelcome();
}
