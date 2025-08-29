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
  });

  factory Givt.fromJson(Map<String, dynamic> json) {
    var taxYear = 0;
    final timestamp = DateTime.parse(json['Timestamp'] as String);
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
      id: json['Id'] as int,
      amount: json['Amount'] as double,
      collectGroupId: json['CollectGroupId'] as String,
      organisationName: json['OrgName'] as String,
      organisationTaxDeductible: json.containsKey('OrganisationTaxDeductible')
          ? json['OrganisationTaxDeductible'] as bool
          : false,
      collectId: int.parse(json['CollectId'] as String),
      isGiftAidEnabled: json['GiftAidEnabled'] as bool,
      status: json['Status'] as int,
      timeStamp: timestamp,
      mediumId: json['MediumId'] as String,
      taxYear: taxYear,
      donationType:
          json.containsKey('DonationType') ? json['DonationType'] as int : 0,
      platformFeeTransactionId: json['PlatformFeeTransactionId'] as int?,
      platformFeeAmount: json['PlatformFeeAmount'] as double?,
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
        platformFeeAmount = null;

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
      ];
}
