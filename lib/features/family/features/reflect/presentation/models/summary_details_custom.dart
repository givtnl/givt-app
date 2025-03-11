import 'package:givt_app/features/family/shared/widgets/dialogs/models/fun_dialog_uimodel.dart';

sealed class SummaryDetailsCustom {
  const SummaryDetailsCustom();

  const factory SummaryDetailsCustom.showConfetti() = ShowConfetti;

  const factory SummaryDetailsCustom.navigateToNextScreen() =
      NavigateToNextScreen;

  const factory SummaryDetailsCustom.showInterviewPopup(
    FunDialogUIModel uiModel, {
    bool useDefaultImage,
  }) = ShowInterviewPopup;
}

class ShowConfetti extends SummaryDetailsCustom {
  const ShowConfetti();
}

class NavigateToNextScreen extends SummaryDetailsCustom {
  const NavigateToNextScreen();
}

class ShowInterviewPopup extends SummaryDetailsCustom {
  const ShowInterviewPopup(this.uiModel, {this.useDefaultImage = true});

  final FunDialogUIModel uiModel;
  final bool useDefaultImage;
}
