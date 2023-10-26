part of 'decision_cubit.dart';

enum DecisionStatus { initial, loading, made, error }

class DecisionState extends Equatable {
  const DecisionState({
    required this.donation,
    required this.status,
    this.response,
  });

  const DecisionState.initial()
      : donation = const ChildDonation.empty(),
        status = DecisionStatus.initial,
        response = null;

  final ChildDonation donation;
  final DecisionStatus status;
  final DecisionResponse? response;

  @override
  List<Object?> get props => [donation, status, response];

  DecisionState copyWith({
    ChildDonation? donation,
    DecisionStatus? status,
    DecisionResponse? response,
  }) {
    return DecisionState(
      donation: donation ?? this.donation,
      status: status ?? this.status,
      response: response ?? this.response,
    );
  }
}
