sealed class GenerosityChallengeVpcSetupCustom {
  const GenerosityChallengeVpcSetupCustom();

  const factory GenerosityChallengeVpcSetupCustom.navigateToFamilyOverview() =
      NavigateToFamilyOverview;

  const factory GenerosityChallengeVpcSetupCustom.navigateToLogin() =
      NavigateToLogin;
}

class NavigateToFamilyOverview extends GenerosityChallengeVpcSetupCustom {
  const NavigateToFamilyOverview();
}

class NavigateToLogin extends GenerosityChallengeVpcSetupCustom {
  const NavigateToLogin();
}
