sealed class NavigationBarHomeCustom {
  const NavigationBarHomeCustom();

  const factory NavigationBarHomeCustom.showBoxOrignDialog() = BoxOrignDialog;

  const factory NavigationBarHomeCustom.familyNotSetup() = FamilyNotSetup;
}

class BoxOrignDialog extends NavigationBarHomeCustom {
  const BoxOrignDialog();
}

class FamilyNotSetup extends NavigationBarHomeCustom {
  const FamilyNotSetup();
}
