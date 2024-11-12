sealed class NavigationBarHomeCustom {
  const NavigationBarHomeCustom();

  const factory NavigationBarHomeCustom.showPreferredChurchDialog() =
      PreferredChurchDialog;

}

class PreferredChurchDialog extends NavigationBarHomeCustom {
  const PreferredChurchDialog();
}
