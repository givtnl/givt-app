import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/features/family/features/history/models/history_item.dart';

class Donation extends HistoryItem {
  const Donation({
    required super.amount,
    required super.date,
    required this.organizationName,
    required this.state,
    required this.medium,
    required super.type,
    required this.goalId,
  });

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      amount: double.tryParse(map['amount'].toString()) ?? 0,
      date: DateTime.tryParse(map['donationDate'] as String) ?? DateTime.now(),
      organizationName: map['collectGroupName'] as String,
      state: DonationState.getState(map['status'] as String),
      medium: DonationMediumType.values.firstWhere(
        (element) => element.type == map['mediumType'],
        orElse: () => DonationMediumType.unknown,
      ),
      type: HistoryTypes.values.firstWhere(
        (element) => element.value == map['donationType'],
        orElse: () => HistoryTypes.donation,
      ),
      goalId: map['goalId'] as String,
    );
  }

  Donation.empty()
      : this(
          amount: 0,
          date: DateTime.now(),
          organizationName: '',
          state: DonationState.pending,
          medium: DonationMediumType.qr,
          type: HistoryTypes.donation,
          goalId: '',
        );
  final String organizationName;
  final DonationState state;
  final DonationMediumType medium;
  final String goalId;

  bool get isToGoal {
    return goalId.isNotEmpty;
  }

  @override
  List<Object?> get props => [
        amount,
        date,
        organizationName,
        state,
        medium,
        goalId,
      ];

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'donationDate': date.toString(),
      'collectGroupName': organizationName,
      'status': DonationState.getDonationStateString(state),
      'mediumType': medium.type,
      'donationType': type.value,
      'goalId': goalId,
    };
  }
}
