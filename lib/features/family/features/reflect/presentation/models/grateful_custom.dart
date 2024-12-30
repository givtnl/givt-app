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

  const factory GratefulCustom.goToGameSummary() = GratefulGoToGameSummary;

  const factory GratefulCustom.scrollToTop() = ScrollToTop;
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

class GratefulGoToGameSummary extends GratefulCustom {
  const GratefulGoToGameSummary();
}

class ScrollToTop extends GratefulCustom {
  const ScrollToTop();
}
