part of 'add_external_donation_cubit.dart';

enum AddExternalDonationStatus { initial, loading, success, error }

class AddExternalDonationState extends Equatable {
  const AddExternalDonationState({
    this.status = AddExternalDonationStatus.initial,
    this.externalDonations = const [],
  });

  final AddExternalDonationStatus status;
  final List<ExternalDonation> externalDonations;

  AddExternalDonationState copyWith({
    AddExternalDonationStatus? status,
    List<ExternalDonation>? externalDonations,
  }) {
    return AddExternalDonationState(
      status: status ?? this.status,
      externalDonations: externalDonations ?? this.externalDonations,
    );
  }

  @override
  List<Object> get props => [status, externalDonations];
}
