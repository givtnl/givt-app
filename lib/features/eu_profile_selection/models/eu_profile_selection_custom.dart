sealed class EuProfileSelectionCustom {
  const EuProfileSelectionCustom();
  
  const factory EuProfileSelectionCustom.navigateToProfile(String profileId) = NavigateToProfile;
  const factory EuProfileSelectionCustom.showAddProfileDialog() = ShowAddProfileDialog;
}

class NavigateToProfile extends EuProfileSelectionCustom {
  const NavigateToProfile(this.profileId);
  
  final String profileId;
}

class ShowAddProfileDialog extends EuProfileSelectionCustom {
  const ShowAddProfileDialog();
}
