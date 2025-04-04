sealed class ReflectIntroCustom {
  const ReflectIntroCustom();
  
  const factory ReflectIntroCustom.goToStageScreen() = GoToStageScreen;
}

class GoToStageScreen extends ReflectIntroCustom {
  const GoToStageScreen();
}