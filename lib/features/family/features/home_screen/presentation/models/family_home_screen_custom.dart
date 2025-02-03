import 'package:givt_app/features/family/features/home_screen/presentation/models/family_home_screen.uimodel.dart';

sealed class FamilyHomeScreenCustom {
  const FamilyHomeScreenCustom();

  const factory FamilyHomeScreenCustom.slideCarousel(int tabIndex) =
      SlideCarouselTo;

  const factory FamilyHomeScreenCustom.openAvatarOverlay(
    FamilyHomeScreenUIModel uiModel, {
    bool withTutorial,
  }) = OpenAvatarOverlay;

  const factory FamilyHomeScreenCustom.startTutorial() = StartTutorial;
}

class SlideCarouselTo extends FamilyHomeScreenCustom {
  const SlideCarouselTo(this.carrouselIndex);

  final int carrouselIndex;
}

class OpenAvatarOverlay extends FamilyHomeScreenCustom {
  const OpenAvatarOverlay(this.uiModel, {this.withTutorial = false});

  final FamilyHomeScreenUIModel uiModel;
  final bool withTutorial;
}

class StartTutorial extends FamilyHomeScreenCustom {
  const StartTutorial();
}
