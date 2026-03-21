import 'package:givt_app/core/enums/analytics_event_name.dart';

/// Temporary shim to keep legacy `AmplitudeEvents` references working
/// while the app migrates to `AnalyticsEventName` / PostHog.
///
/// Each static const maps directly to an `AnalyticsEventName` value.
class AmplitudeEvents {
  // Give flow
  static const giveButtonPressed = AnalyticsEventName.giveButtonPressed;
  static const giveHomeTabsChanged = AnalyticsEventName.giveHomeTabsChanged;
  static const forYouSearchTapped = AnalyticsEventName.forYouSearchTapped;
  static const forYouOtherWaysLocationTapped =
      AnalyticsEventName.forYouOtherWaysLocationTapped;
  static const forYouOtherWaysQrTapped =
      AnalyticsEventName.forYouOtherWaysQrTapped;
  static const forYouOtherWaysBeaconTapped =
      AnalyticsEventName.forYouOtherWaysBeaconTapped;
  static const forYouOrganisationConfirmGiveTapped =
      AnalyticsEventName.forYouOrganisationConfirmGiveTapped;

  // Gift Aid registration
  static const giftAidRegistrationLearnMoreClicked =
      AnalyticsEventName.giftAidRegistrationLearnMoreClicked;
  static const giftAidRegistrationDoneClicked =
      AnalyticsEventName.giftAidRegistrationDoneClicked;
  static const giftAidRegistrationCheckboxChanged =
      AnalyticsEventName.giftAidRegistrationCheckboxChanged;
  static const giftAidRegistrationActivateClicked =
      AnalyticsEventName.giftAidRegistrationActivateClicked;
  static const giftAidRegistrationSetUpLaterClicked =
      AnalyticsEventName.giftAidRegistrationSetUpLaterClicked;
}
