sealed class NavigationBarHomeCustom {
  const NavigationBarHomeCustom();

  const factory NavigationBarHomeCustom.switchTab(int tabIndex) = SwitchTab;

  const factory NavigationBarHomeCustom.showTutorialPopup() = TutorialPopup;
}

class SwitchTab extends NavigationBarHomeCustom {
  const SwitchTab(this.tabIndex);

  final int tabIndex;
}

class TutorialPopup extends NavigationBarHomeCustom {
  const TutorialPopup();
}
