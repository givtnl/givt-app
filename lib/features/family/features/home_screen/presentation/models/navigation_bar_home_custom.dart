sealed class NavigationBarHomeCustom {
  const NavigationBarHomeCustom();

  const factory NavigationBarHomeCustom.showPreferredChurchDialog() =
      PreferredChurchDialog;

  const factory NavigationBarHomeCustom.familyNotSetup() = FamilyNotSetup;
}

class PreferredChurchDialog extends NavigationBarHomeCustom {
  const PreferredChurchDialog();
}

class FamilyNotSetup extends NavigationBarHomeCustom {
  const FamilyNotSetup();
}
