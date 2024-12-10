import 'package:givt_app/features/family/features/family_history/models/child_donation_helper.dart';
import 'package:givt_app/features/family/features/family_history/models/history_item.dart';

class ChildDonation extends HistoryItem {
  const ChildDonation({
    required super.amount,
    required super.date,
    required this.organizationName,
    required this.state,
    required this.medium,
    required super.type,
    required super.name,
    required this.userId,
    required this.id,
    required this.goalId,
  });

  const ChildDonation.empty()
      : this(
          amount: 0,
          date: '',
          organizationName: '',
          state: DonationState.pending,
          medium: DonationMediumType.qr,
          type: HistoryTypes.donation,
          name: '',
          userId: '',
          id: -1,
          goalId: '',
        );

  factory ChildDonation.fromMap(Map<String, dynamic> map) {
    final name = (map['donor'] as Map<String, dynamic>? ?? {})['firstName'];
    return ChildDonation(
      name: name as String? ?? '',
      amount: double.tryParse(map['amount'].toString()) ?? 0,
      date: map['donationDate'].toString(),
      organizationName: map['collectGroupName'].toString(),
      state: DonationState.getState(map['status'].toString()),
      userId: map['userId'].toString(),
      id: map['id'] as int? ?? -1,
      medium: map['donationMedium'] != null
          ? DonationMediumType.fromString(
              map['donationMedium'].toString(),
            )
          : DonationMediumType.unknown,
      type: HistoryTypes.fromString(
        map['donationType'].toString(),
      ),
      goalId: (map['goalId'] ?? '').toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'donationDate': date,
      'donationType': type.value,
      'donor': {'firstName': name},
      'collectGroupName': organizationName,
      'status': DonationState.getDonationStateString(state),
      'userId': userId,
      'id': id,
      'donationMedium': medium,
      'goalId': goalId,
    };
  }

  final String organizationName;
  final DonationState state;
  final DonationMediumType medium;
  final String userId;
  final int id;
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
        name,
        type,
        userId,
        id,
        goalId,
      ];
}
