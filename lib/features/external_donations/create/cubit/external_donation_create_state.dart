part of 'external_donation_create_cubit.dart';

sealed class ExternalDonationCreateCustom {
  const ExternalDonationCreateCustom();

  const factory ExternalDonationCreateCustom.navigateToDonationType() =
      NavigateToDonationType;

  const factory ExternalDonationCreateCustom.navigateToOneOffDate() =
      NavigateToOneOffDate;

  const factory ExternalDonationCreateCustom.navigateToSeriesStartDate() =
      NavigateToSeriesStartDate;

  const factory ExternalDonationCreateCustom.navigateToSuccess() =
      NavigateToSuccess;
}

final class NavigateToDonationType extends ExternalDonationCreateCustom {
  const NavigateToDonationType();
}

final class NavigateToOneOffDate extends ExternalDonationCreateCustom {
  const NavigateToOneOffDate();
}

final class NavigateToSeriesStartDate extends ExternalDonationCreateCustom {
  const NavigateToSeriesStartDate();
}

final class NavigateToSuccess extends ExternalDonationCreateCustom {
  const NavigateToSuccess();
}
