sealed class NavigationBarHomeCustom {
  const NavigationBarHomeCustom();

  const factory NavigationBarHomeCustom.switchTab(int tabIndex) = SwitchTab;

}

class SwitchTab extends NavigationBarHomeCustom {
  const SwitchTab(this.tabIndex);

  final int tabIndex;
}