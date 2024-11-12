sealed class NavigationBarHomeCustom {
  const NavigationBarHomeCustom();

  const factory NavigationBarHomeCustom.showBoxOriginDialog() = BoxOriginDialog;

  const factory NavigationBarHomeCustom.familyNotSetup() = FamilyNotSetup;
}

class BoxOriginDialog extends NavigationBarHomeCustom {
  const BoxOriginDialog();
}

class FamilyNotSetup extends NavigationBarHomeCustom {
  const FamilyNotSetup();
}
