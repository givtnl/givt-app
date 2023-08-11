import 'package:equatable/equatable.dart';
import 'package:givt_app/features/overview/models/givt.dart';

class RecurringDonationDetail extends Equatable {
  const RecurringDonationDetail({
    required this.timestamp,
    required this.donationId,
    required this.amount,
    this.status = 3,
    this.isGiftAidEnabled = false,
  });
  factory RecurringDonationDetail.fromJson(Map<String, dynamic> json) {
    return RecurringDonationDetail(
      timestamp: DateTime.parse(json['confirmationDateTime'] as String),
      donationId: json['donationId'].toString(),
      amount: json['amount'] as int,
    );
  }
  factory RecurringDonationDetail.fromGivt(Givt givt) {
    return RecurringDonationDetail(
      timestamp: givt.timeStamp!.toLocal(),
      donationId: givt.id.toString(),
      amount: givt.amount.toInt(),
      status: givt.status,
      isGiftAidEnabled: givt.isGiftAidEnabled,
    );
  }
  final DateTime timestamp;
  final String donationId;
  final int amount;
  final int status;
  final bool isGiftAidEnabled;

  static List<RecurringDonationDetail> fromJsonList(List<dynamic> jsonList) =>
      jsonList
          .map(
            (dynamic json) => RecurringDonationDetail.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();

  static List<RecurringDonationDetail> fromGivtsList(List<Givt> givtsList) =>
      givtsList
          .map(
            (dynamic givt) => RecurringDonationDetail.fromGivt(
              givt as Givt,
            ),
          )
          .toList();

  @override
  List<Object> get props => [timestamp, donationId, amount, status];
}
