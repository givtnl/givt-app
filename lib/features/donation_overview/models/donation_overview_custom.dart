sealed class DonationOverviewCustom {
  const DonationOverviewCustom();

  const factory DonationOverviewCustom.donationDeleteFailed(String error) =
      DonationDeleteFailed;
  const factory DonationOverviewCustom.showSuccessMessage(String message) =
      ShowSuccessMessage;
  const factory DonationOverviewCustom.showErrorMessage(String error) =
      ShowErrorMessage;
}

class DonationDeleteFailed extends DonationOverviewCustom {
  const DonationDeleteFailed(this.error);

  final String error;
}

class ShowSuccessMessage extends DonationOverviewCustom {
  const ShowSuccessMessage(this.message);

  final String message;
}

class ShowErrorMessage extends DonationOverviewCustom {
  const ShowErrorMessage(this.error);

  final String error;
}
