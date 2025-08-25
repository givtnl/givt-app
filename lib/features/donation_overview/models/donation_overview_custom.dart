import 'package:equatable/equatable.dart';

sealed class DonationOverviewCustom {
  const DonationOverviewCustom();
  
  const factory DonationOverviewCustom.showDeleteConfirmation(List<int> ids) = ShowDeleteConfirmation;
  const factory DonationOverviewCustom.showDonationDetails(int donationId) = ShowDonationDetails;
  const factory DonationOverviewCustom.donationDeleted() = DonationDeleted;
  const factory DonationOverviewCustom.donationDeleteFailed(String error) = DonationDeleteFailed;
  const factory DonationOverviewCustom.showSuccessMessage(String message) = ShowSuccessMessage;
  const factory DonationOverviewCustom.showErrorMessage(String error) = ShowErrorMessage;
}

class ShowDeleteConfirmation extends DonationOverviewCustom {
  const ShowDeleteConfirmation(this.ids);
  
  final List<int> ids;
}

class ShowDonationDetails extends DonationOverviewCustom {
  const ShowDonationDetails(this.donationId);
  
  final int donationId;
}

class DonationDeleted extends DonationOverviewCustom {
  const DonationDeleted();
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
