import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

sealed class GratefulCustom {
  const GratefulCustom();

  const factory GratefulCustom.openKidDonationFlow(
      {required GameProfile profile,
      required Organisation organisation,}) = GratefulOpenKidDonationFlow;

  const factory GratefulCustom.openParentDonationFlow(
      {required GameProfile profile,
      required Organisation organisation,}) = GratefulOpenParentDonationFlow;

  const factory GratefulCustom.goToGameSummary() = GratefulGoToGameSummary;
}

class GratefulOpenKidDonationFlow extends GratefulCustom {
  const GratefulOpenKidDonationFlow(
      {required this.profile, required this.organisation,});

  final GameProfile profile;
  final Organisation organisation;
}

class GratefulOpenParentDonationFlow extends GratefulCustom {
  const GratefulOpenParentDonationFlow(
      {required this.profile, required this.organisation,});

  final GameProfile profile;
  final Organisation organisation;
}

class GratefulGoToGameSummary extends GratefulCustom {
  const GratefulGoToGameSummary();
}
