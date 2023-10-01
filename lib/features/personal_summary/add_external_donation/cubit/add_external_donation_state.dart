part of 'add_external_donation_cubit.dart';

enum AddExternalDonationStatus { initial, loading, success, error }

class AddExternalDonationState extends Equatable {
  const AddExternalDonationState({
    this.status = AddExternalDonationStatus.initial,
  });

  final AddExternalDonationStatus status;

  @override
  List<Object> get props => [status];
}
