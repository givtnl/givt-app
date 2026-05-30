part of 'external_donation_detail_cubit.dart';

class ExternalDonationDetailUIModel {
  const ExternalDonationDetailUIModel({
    required this.donation,
    required this.totalDonated,
    required this.givingDays,
    required this.history,
    required this.isRecurring,
    required this.isActive,
    required this.isLoading,
  });

  final ExternalDonation donation;
  final double totalDonated;
  final int givingDays;
  final List<ExternalDonationHistoryItem> history;
  final bool isRecurring;
  final bool isActive;
  final bool isLoading;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExternalDonationDetailUIModel &&
        other.donation == donation &&
        other.totalDonated == totalDonated &&
        other.givingDays == givingDays &&
        other.history == history &&
        other.isRecurring == isRecurring &&
        other.isActive == isActive &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode => Object.hash(
        donation,
        totalDonated,
        givingDays,
        history,
        isRecurring,
        isActive,
        isLoading,
      );
}

sealed class ExternalDonationDetailCustom {
  const ExternalDonationDetailCustom();

  const factory ExternalDonationDetailCustom.showStopRecordingModal() =
      ShowStopRecordingModal;
}

class ShowStopRecordingModal extends ExternalDonationDetailCustom {
  const ShowStopRecordingModal();
}
