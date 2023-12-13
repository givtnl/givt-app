part of 'parental_approval_cubit.dart';

class ParentalApprovalState extends Equatable {
  const ParentalApprovalState({
    required this.donation,
    required this.status,
    this.decisionMade,
  });

  final ChildDonation donation;
  final DecisionStatus status;
  final bool? decisionMade;

  @override
  List<Object?> get props => [donation, status, decisionMade];

  ParentalApprovalState copyWith({
    ChildDonation? donation,
    DecisionStatus? status,
    bool? decisionMade,
  }) {
    return ParentalApprovalState(
      donation: donation ?? this.donation,
      status: status ?? this.status,
      decisionMade: decisionMade ?? this.decisionMade,
    );
  }
}

enum DecisionStatus { confirmation, loading, approved, declined, error, pop }
