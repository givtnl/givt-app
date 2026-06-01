part of 'external_donation_detail_cubit.dart';

class ExternalDonationDetailUIModel {
  const ExternalDonationDetailUIModel({
    required this.donation,
    required this.totalDonated,
    required this.givingDuration,
    required this.oneOffTransactionDate,
    required this.history,
    required this.isRecurring,
    required this.isActive,
  });

  final ExternalDonation donation;
  final double totalDonated;
  final GivingDuration? givingDuration;
  final DateTime? oneOffTransactionDate;
  final List<ExternalDonationHistoryItem> history;
  final bool isRecurring;
  final bool isActive;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExternalDonationDetailUIModel &&
        other.donation == donation &&
        other.totalDonated == totalDonated &&
        other.givingDuration == givingDuration &&
        other.oneOffTransactionDate == oneOffTransactionDate &&
        other.history == history &&
        other.isRecurring == isRecurring &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => Object.hash(
        donation,
        totalDonated,
        givingDuration,
        oneOffTransactionDate,
        history,
        isRecurring,
        isActive,
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
