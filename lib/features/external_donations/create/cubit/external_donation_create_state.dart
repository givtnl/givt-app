part of 'external_donation_create_cubit.dart';

sealed class ExternalDonationCreateCustom {
  const ExternalDonationCreateCustom();

  const factory ExternalDonationCreateCustom.navigateToDonationType() =
      NavigateToDonationType;

  const factory ExternalDonationCreateCustom.navigateToOneOffDate() =
      NavigateToOneOffDate;

  const factory ExternalDonationCreateCustom.navigateToLastGiftDate() =
      NavigateToLastGiftDate;

  const factory ExternalDonationCreateCustom.navigateToStartMonthYear() =
      NavigateToStartMonthYear;

  const factory ExternalDonationCreateCustom.navigateToSuccess() =
      NavigateToSuccess;
}

final class NavigateToDonationType extends ExternalDonationCreateCustom {
  const NavigateToDonationType();
}

final class NavigateToOneOffDate extends ExternalDonationCreateCustom {
  const NavigateToOneOffDate();
}

final class NavigateToLastGiftDate extends ExternalDonationCreateCustom {
  const NavigateToLastGiftDate();
}

final class NavigateToStartMonthYear extends ExternalDonationCreateCustom {
  const NavigateToStartMonthYear();
}

final class NavigateToSuccess extends ExternalDonationCreateCustom {
  const NavigateToSuccess();
}
