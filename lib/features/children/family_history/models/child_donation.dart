import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/features/children/family_history/models/history_item.dart';

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
        );

  factory ChildDonation.fromMap(Map<String, dynamic> map) {
    return ChildDonation(
      name: (map['donor'] as Map<String, dynamic>)['firstName'].toString(),
      amount: double.tryParse(map['amount'].toString()) ?? 0,
      date: map['donationDate'].toString(),
      organizationName: map['collectGroupName'].toString(),
      state: DonationState.getState(map['status'].toString()),
      userId: map['userId'].toString(),
      id: map['id'] as int,
      medium: DonationMediumType.fromString(
        map['donationMedium'] == null ? '' : map['donationMedium'] as String,
      ),
      type: HistoryTypes.fromString(
        map['donationType'] == null ? '' : map['donationType'] as String,
      ),
    );
  }

  final String organizationName;
  final DonationState state;
  final DonationMediumType medium;
  final String userId;
  final int id;

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
      ];
}
