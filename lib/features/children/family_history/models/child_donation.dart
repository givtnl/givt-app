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
  });

  ChildDonation.empty()
      : this(
          amount: 0,
          date: DateTime.now(),
          organizationName: '',
          state: DonationState.pending,
          medium: DonationMediumType.qr,
          type: HistoryTypes.donation,
          name: '',
        );

  factory ChildDonation.fromMap(Map<String, dynamic> map) {
    return ChildDonation(
      name: map['donor']['firstName'].toString(),
      amount: double.tryParse(map['amount'].toString()) ?? 0,
      date: DateTime.tryParse(map['donationDate'].toString()) ?? DateTime.now(),
      organizationName: map['collectGroupName'].toString(),
      state: DonationState.getState(map['status'].toString()),
      medium: DonationMediumType.values.firstWhere(
          (element) => element.type == map['mediumType'],
          orElse: () => DonationMediumType.unknown),
      type: HistoryTypes.values.firstWhere(
        (element) => element.value == map['donationType'],
        orElse: () => HistoryTypes.donation,
      ),
    );
  }

  final String organizationName;
  final DonationState state;
  final DonationMediumType medium;

  @override
  List<Object?> get props => [
        amount,
        date,
        organizationName,
        state,
        medium,
        name,
        type,
      ];

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'donationDate': date.toString(),
      'collectGroupName': organizationName,
      'status': DonationState.getDonationStateString(state),
      'mediumType': medium.type,
      'donationType': type.value,
      'donor': {'firstName': name},
    };
  }
}
