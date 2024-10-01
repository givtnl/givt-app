

sealed class NavigationBarHomeCustom {
  const NavigationBarHomeCustom();

  const factory NavigationBarHomeCustom.showPreferredChurchDialog() =
      PreferredChurchDialog;

  const factory NavigationBarHomeCustom.userNeedsRegistration() =
      UserNeedsRegistration;

  const factory NavigationBarHomeCustom.familyNotSetup() = FamilyNotSetup;
}

class PreferredChurchDialog extends NavigationBarHomeCustom {
  const PreferredChurchDialog();
}

class UserNeedsRegistration extends NavigationBarHomeCustom {
  const UserNeedsRegistration();
}

class FamilyNotSetup extends NavigationBarHomeCustom {
  const FamilyNotSetup();
}
