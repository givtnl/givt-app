import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

sealed class GratefulCustom {
  const GratefulCustom();

  const factory GratefulCustom.openKidDonationFlow({
    required GameProfile profile,
    required Organisation organisation,
  }) = GratefulOpenKidDonationFlow;

  const factory GratefulCustom.openParentDonationFlow({
    required GameProfile profile,
    required Organisation organisation,
  }) = GratefulOpenParentDonationFlow;

  const factory GratefulCustom.openActOfServiceSuccess({
    required Organisation organisation,
    required GameProfile profile,
  }) = GratefulOpenActOfServiceSuccess;

  const factory GratefulCustom.goToGatherAround() = GratefulGoToGatherAround;

  const factory GratefulCustom.scrollToTop() = ScrollToTop;

  const factory GratefulCustom.showDoneOverlay() = ShowDoneOverlay;

  const factory GratefulCustom.showSkippedOverlay() = ShowSkippedOverlay;
}

class GratefulOpenKidDonationFlow extends GratefulCustom {
  const GratefulOpenKidDonationFlow({
    required this.profile,
    required this.organisation,
  });

  final GameProfile profile;
  final Organisation organisation;
}

class GratefulOpenParentDonationFlow extends GratefulCustom {
  const GratefulOpenParentDonationFlow({
    required this.profile,
    required this.organisation,
  });

  final GameProfile profile;
  final Organisation organisation;
}

class GratefulOpenActOfServiceSuccess extends GratefulCustom {
  const GratefulOpenActOfServiceSuccess({
    required this.profile,
    required this.organisation,
  });
  final GameProfile profile;
  final Organisation organisation;
}

class GratefulGoToGatherAround extends GratefulCustom {
  const GratefulGoToGatherAround();
}

class ScrollToTop extends GratefulCustom {
  const ScrollToTop();
}

class ShowDoneOverlay extends GratefulCustom {
  const ShowDoneOverlay();
}

class ShowSkippedOverlay extends GratefulCustom {
  const ShowSkippedOverlay();
}
