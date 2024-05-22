part of 'create_challenge_donation_cubit.dart';

class CreateChallengeDonationState extends Equatable {
  const CreateChallengeDonationState({
    required this.amount,
  });

  static const double maxAvailableAmount = 30;

  final double amount;

  @override
  List<Object> get props => [amount];

  CreateChallengeDonationState copyWith({
    double? amount,
  }) {
    return CreateChallengeDonationState(
      amount: amount ?? this.amount,
    );
  }
}
