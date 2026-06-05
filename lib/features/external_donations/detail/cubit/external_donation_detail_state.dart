part of 'external_donation_detail_cubit.dart';

class ExternalDonationDetailUIModel {
  const ExternalDonationDetailUIModel({
    required this.donation,
    required this.totalDonated,
    required this.givingDuration,
    required this.history,
  });

  final ExternalDonation donation;
  final double totalDonated;
  final GivingDuration? givingDuration;
  final List<ExternalDonationHistoryItem> history;

  bool get isRecurring => donation.isRecurring;

  bool get isActive => donation.active;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExternalDonationDetailUIModel &&
        other.donation == donation &&
        other.totalDonated == totalDonated &&
        other.givingDuration == givingDuration &&
        other.history == history;
  }

  @override
  int get hashCode => Object.hash(
        donation,
        totalDonated,
        givingDuration,
        history,
      );
}

sealed class ExternalDonationDetailCustom {
  const ExternalDonationDetailCustom();

  const factory ExternalDonationDetailCustom.showStopRecordingModal() =
      ShowStopRecordingModal;

  const factory ExternalDonationDetailCustom.stopRecordingSucceeded() =
      StopRecordingSucceeded;

  const factory ExternalDonationDetailCustom.stopRecordingFailed() =
      StopRecordingFailed;
}

class ShowStopRecordingModal extends ExternalDonationDetailCustom {
  const ShowStopRecordingModal();
}

class StopRecordingSucceeded extends ExternalDonationDetailCustom {
  const StopRecordingSucceeded();
}

class StopRecordingFailed extends ExternalDonationDetailCustom {
  const StopRecordingFailed();
}
