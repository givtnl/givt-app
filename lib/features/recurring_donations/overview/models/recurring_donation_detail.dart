import 'package:equatable/equatable.dart';

class RecurringDonationDetail extends Equatable {
  const RecurringDonationDetail({
    required this.timestamp,
    required this.donationId,
    //required this.count,
    // required this.status,
    // required this.isGiftAidEnabled,
  });
  factory RecurringDonationDetail.fromJson(Map<String, dynamic> json) {
    return RecurringDonationDetail(
      timestamp: DateTime.parse(json['confirmationDateTime'] as String),
      donationId: json['donationId'] as String,
      // status: json['Status'] as int,
      // isGiftAidEnabled: json['GiftAidEnabled'] as bool,
      //count: json['Count'] as int,
    );
  }
  final DateTime timestamp;
  final String donationId;
  //final int count;
  // final int status;
  // final bool isGiftAidEnabled;

  static List<RecurringDonationDetail> fromJsonList(List<dynamic> jsonList) =>
      jsonList
          .map(
            (dynamic json) => RecurringDonationDetail.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();

  @override
  List<Object> get props => [
        timestamp,
        donationId,
        //count,
        // status,
        // isGiftAidEnabled,
      ];
}
