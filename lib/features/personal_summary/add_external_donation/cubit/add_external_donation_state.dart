part of 'add_external_donation_cubit.dart';

enum AddExternalDonationStatus { initial, loading, success, error }

class AddExternalDonationState extends Equatable {
  const AddExternalDonationState({
    required this.dateTime,
    this.status = AddExternalDonationStatus.initial,
    this.externalDonations = const [],
    this.currentExternalDonation = const ExternalDonation.empty(),
    this.isEdit = false,
  });

  final AddExternalDonationStatus status;
  final List<ExternalDonation> externalDonations;
  final ExternalDonation currentExternalDonation;
  final String dateTime;
  final bool isEdit;

  AddExternalDonationState copyWith({
    AddExternalDonationStatus? status,
    List<ExternalDonation>? externalDonations,
    List<ExternalDonation>? toBeRemoved,
    ExternalDonation? currentExternalDonation,
    String? dateTime,
    bool? isEdit,
  }) {
    return AddExternalDonationState(
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      externalDonations: externalDonations ?? this.externalDonations,
      currentExternalDonation:
          currentExternalDonation ?? this.currentExternalDonation,
      isEdit: isEdit ?? this.isEdit,
    );
  }

  @override
  List<Object> get props => [
        isEdit,
        dateTime,
        status,
        externalDonations,
        currentExternalDonation,
      ];
}
