sealed class EditAvatarCustom {
  const EditAvatarCustom();

  const factory EditAvatarCustom.navigateToProfile() = NavigateToProfile;
  const factory EditAvatarCustom.showSaveOnBackDialog() = ShowSaveOnBackDialog;
}

class NavigateToProfile extends EditAvatarCustom {
  const NavigateToProfile();
}

class ShowSaveOnBackDialog extends EditAvatarCustom {
  const ShowSaveOnBackDialog();
}