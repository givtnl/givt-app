import 'package:givt_app/features/family/shared/widgets/dialogs/models/fun_dialog_uimodel.dart';

sealed class InGameLeagueCustom {
  const InGameLeagueCustom();

  const factory InGameLeagueCustom.showConfetti() = ShowConfetti;

  const factory InGameLeagueCustom.navigateToProfileSelection() =
      NavigateToProfileSelection;

  const factory InGameLeagueCustom.showInterviewPopup(
    FunDialogUIModel uiModel, {
    bool useDefaultImage,
  }) = ShowInterviewPopup;
}

class ShowConfetti extends InGameLeagueCustom {
  const ShowConfetti();
}

class NavigateToProfileSelection extends InGameLeagueCustom {
  const NavigateToProfileSelection();
}

class ShowInterviewPopup extends InGameLeagueCustom {
  const ShowInterviewPopup(this.uiModel, {this.useDefaultImage = true});

  final FunDialogUIModel uiModel;
  final bool useDefaultImage;
}
