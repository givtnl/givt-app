sealed class NavigationBarHomeCustom {
  const NavigationBarHomeCustom();

  const factory NavigationBarHomeCustom.showBoxOriginDialog() = BoxOriginDialog;

  const factory NavigationBarHomeCustom.switchTab(int tabIndex) = SwitchTab;

}

class BoxOriginDialog extends NavigationBarHomeCustom {
  const BoxOriginDialog();
}

class SwitchTab extends NavigationBarHomeCustom {
  const SwitchTab(this.tabIndex);

  final int tabIndex;
}