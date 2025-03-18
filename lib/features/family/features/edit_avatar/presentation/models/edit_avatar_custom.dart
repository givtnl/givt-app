import 'package:givt_app/features/family/features/edit_avatar/presentation/models/looking_good_uimodel.dart';

sealed class EditAvatarCustom {
  const EditAvatarCustom();

  const factory EditAvatarCustom.navigateToProfile() = NavigateToProfile;
  const factory EditAvatarCustom.showSaveOnBackDialog() = ShowSaveOnBackDialog;
  const factory EditAvatarCustom.navigateToLookingGoodScreen(
    LookingGoodUIModel uiModel,
  ) = NavigateToLookingGoodScreen;
}

class NavigateToProfile extends EditAvatarCustom {
  const NavigateToProfile();
}

class ShowSaveOnBackDialog extends EditAvatarCustom {
  const ShowSaveOnBackDialog();
}

class NavigateToLookingGoodScreen extends EditAvatarCustom {
  const NavigateToLookingGoodScreen(this.uiModel);

  final LookingGoodUIModel uiModel;
}
