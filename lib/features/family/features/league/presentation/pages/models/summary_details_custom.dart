import 'package:givt_app/features/family/features/reward/presentation/models/reward_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/models/fun_dialog_uimodel.dart';

sealed class InGameLeagueCustom {
  const InGameLeagueCustom();

  const factory InGameLeagueCustom.showConfetti() = ShowConfetti;

  const factory InGameLeagueCustom.navigateToProfileSelection() =
      NavigateToProfileSelection;

  const factory InGameLeagueCustom.navigateToRewardScreen(
    RewardUIModel uiModel,
  ) = NavigateToRewardScreen;

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

class NavigateToRewardScreen extends InGameLeagueCustom {
  const NavigateToRewardScreen(this.uiModel);

  final RewardUIModel uiModel;
}

class ShowInterviewPopup extends InGameLeagueCustom {
  const ShowInterviewPopup(this.uiModel, {this.useDefaultImage = true});

  final FunDialogUIModel uiModel;
  final bool useDefaultImage;
}
