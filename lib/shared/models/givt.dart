import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Givt extends Equatable {
  const Givt({
    required this.id,
    required this.amount,
    required this.collectGroupId,
    required this.organisationName,
    required this.organisationTaxDeductible,
    required this.collectId,
    required this.isGiftAidEnabled,
    required this.status,
    required this.timeStamp,
    required this.mediumId,
    required this.taxYear,
    this.donationType = 0,
    this.platformFeeTransactionId,
    this.platformFeeAmount,
    this.userId,
  });

  factory Givt.fromJson(Map<String, dynamic> json) {
    var taxYear = 0;
    final timestamp = DateTime.parse(json['timestamp'] as String);
    final month = int.parse(
      DateFormat('M').format(timestamp),
    );
    final day = int.parse(
      DateFormat('d').format(timestamp),
    );
    taxYear = int.parse(
      DateFormat('yyyy').format(timestamp),
    );
    if (month <= 3 || (month == 4 && day <= 5)) {
      taxYear = int.parse(DateFormat('yyyy').format(timestamp)) - 1;
    }
    return Givt(
      id: json['id'] as int,
      amount: json['amount'] as double,
      collectGroupId: json['collectGroupId'] as String,
      organisationName: json['orgName'] as String? ?? '',
      organisationTaxDeductible: json.containsKey('organisationTaxDeductible')
          ? json['organisationTaxDeductible'] as bool
          : false,
      collectId: int.parse(json['collectId'] as String),
      isGiftAidEnabled: json['giftAidEnabled'] as bool,
      status: json['status'] as int,
      timeStamp: timestamp,
      mediumId: json['mediumId'] as String? ?? '',
      taxYear: taxYear,
      donationType:
          json.containsKey('donationType') ? json['donationType'] as int : 0,
      platformFeeTransactionId: json['platformFeeTransactionId'] as int?,
      platformFeeAmount: json['platformFeeAmount'] as double?,
      userId: json['userId'] as String?,
    );
  }

  const Givt.empty()
      : id = 0,
        amount = 0,
        taxYear = 0,
        collectGroupId = '',
        organisationName = '',
        organisationTaxDeductible = false,
        collectId = 0,
        isGiftAidEnabled = false,
        status = 0,
        timeStamp = null,
        mediumId = '',
        donationType = 0,
        platformFeeTransactionId = null,
        platformFeeAmount = null,
        userId = null;

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Amount': amount,
      'CollectGroupId': collectGroupId,
      'OrgName': organisationName,
      'OrganisationTaxDeductible': organisationTaxDeductible,
      'CollectId': collectId,
      'GiftAidEnabled': isGiftAidEnabled,
      'Status': status,
      'Timestamp': timeStamp?.toIso8601String(),
      'MediumId': mediumId,
      'TaxYear': taxYear,
      'DonationType': donationType,
      'PlatformFeeTransactionId': platformFeeTransactionId,
      'PlatformFeeAmount': platformFeeAmount,
      'UserId': userId,
    };
  }

  static List<Givt> fromJsonList(List<dynamic> jsonList) => jsonList
      .map(
        (dynamic json) => Givt.fromJson(
          json as Map<String, dynamic>,
        ),
      )
      .toList();

  final int id;
  final double amount;
  final String collectGroupId;
  final String organisationName;
  final bool organisationTaxDeductible;
  final int collectId;
  final bool isGiftAidEnabled;
  final int status;
  final DateTime? timeStamp;
  final String mediumId;
  final int taxYear;
  final int donationType;
  final int? platformFeeTransactionId;
  final double? platformFeeAmount;
  final String? userId;

  Givt copyWith({
    int? id,
    double? amount,
    String? collectGroupId,
    String? organisationName,
    bool? organisationTaxDeductible,
    int? collectId,
    bool? isGiftAid,
    int? status,
    DateTime? timeStamp,
    String? mediumId,
    int? taxYear,
    int? donationType,
    int? platformFeeTransactionId,
    double? platformFeeAmount,
    String? userId,
  }) =>
      Givt(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        taxYear: taxYear ?? this.taxYear,
        collectGroupId: collectGroupId ?? this.collectGroupId,
        organisationName: organisationName ?? this.organisationName,
        organisationTaxDeductible:
            organisationTaxDeductible ?? this.organisationTaxDeductible,
        collectId: collectId ?? this.collectId,
        isGiftAidEnabled: isGiftAid ?? isGiftAidEnabled,
        status: status ?? this.status,
        timeStamp: timeStamp ?? this.timeStamp,
        mediumId: mediumId ?? this.mediumId,
        donationType: donationType ?? this.donationType,
        platformFeeTransactionId:
            platformFeeTransactionId ?? this.platformFeeTransactionId,
        platformFeeAmount: platformFeeAmount ?? this.platformFeeAmount,
        userId: userId ?? this.userId,
      );

  @override
  List<Object?> get props => [
        id,
        amount,
        collectGroupId,
        organisationName,
        organisationTaxDeductible,
        collectId,
        isGiftAidEnabled,
        status,
        timeStamp,
        mediumId,
        donationType,
        platformFeeTransactionId,
        platformFeeAmount,
        userId,
      ];
}
