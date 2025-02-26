sealed class ReflectIntroCustom {
  const ReflectIntroCustom();

  const factory ReflectIntroCustom.showCaptainAiPopup() = CaptainAiPopup;

  const factory ReflectIntroCustom.goToStageScreen() = GoToStageScreen;
}

class CaptainAiPopup extends ReflectIntroCustom {
  const CaptainAiPopup();
}

class GoToStageScreen extends ReflectIntroCustom {
  const GoToStageScreen();
}