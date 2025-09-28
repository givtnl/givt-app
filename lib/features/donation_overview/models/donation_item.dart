import 'package:equatable/equatable.dart';
import 'package:givt_app/features/donation_overview/models/donation_status.dart';
import 'package:givt_app/shared/models/givt.dart';

class DonationItem extends Equatable {
  const DonationItem({
    required this.id,
    required this.amount,
    required this.organisationName,
    required this.organisationTaxDeductible,
    required this.isGiftAidEnabled,
    required this.status,
    required this.timeStamp,
    required this.mediumId,
    required this.taxYear,
    required this.donationType,
    this.platformFeeTransactionId,
    this.platformFeeAmount,
    this.collectGroupId,
    this.collectId,
    this.userId,
  });

  factory DonationItem.fromGivt(Givt givt) {
    return DonationItem(
      id: givt.id,
      amount: givt.amount,
      organisationName: givt.organisationName,
      organisationTaxDeductible: givt.organisationTaxDeductible,
      isGiftAidEnabled: givt.isGiftAidEnabled,
      status: DonationStatus.fromLegacyStatus(givt.status),
      timeStamp: givt.timeStamp,
      mediumId: givt.mediumId,
      taxYear: givt.taxYear,
      donationType: givt.donationType,
      platformFeeTransactionId: givt.platformFeeTransactionId,
      platformFeeAmount: givt.platformFeeAmount,
      collectGroupId: givt.collectGroupId,
      collectId: givt.collectId,
      userId: givt.userId,
    );
  }

  final int id;
  final double amount;
  final String organisationName;
  final bool organisationTaxDeductible;
  final bool isGiftAidEnabled;
  final DonationStatus status;
  final DateTime? timeStamp;
  final String mediumId;
  final int taxYear;
  final int donationType;
  final int? platformFeeTransactionId;
  final double? platformFeeAmount;
  final String? collectGroupId;
  final int? collectId;
  final String? userId;

  DonationItem copyWith({
    int? id,
    double? amount,
    String? organisationName,
    bool? organisationTaxDeductible,
    bool? isGiftAidEnabled,
    DonationStatus? status,
    DateTime? timeStamp,
    String? mediumId,
    int? taxYear,
    int? donationType,
    int? platformFeeTransactionId,
    double? platformFeeAmount,
    String? collectGroupId,
    int? collectId,
    String? userId,
  }) {
    return DonationItem(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      organisationName: organisationName ?? this.organisationName,
      organisationTaxDeductible: organisationTaxDeductible ?? this.organisationTaxDeductible,
      isGiftAidEnabled: isGiftAidEnabled ?? this.isGiftAidEnabled,
      status: status ?? this.status,
      timeStamp: timeStamp ?? this.timeStamp,
      mediumId: mediumId ?? this.mediumId,
      taxYear: taxYear ?? this.taxYear,
      donationType: donationType ?? this.donationType,
      platformFeeTransactionId: platformFeeTransactionId ?? this.platformFeeTransactionId,
      platformFeeAmount: platformFeeAmount ?? this.platformFeeAmount,
      collectGroupId: collectGroupId ?? this.collectGroupId,
      collectId: collectId ?? this.collectId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() {

    return {
      'id': id,
        'amount': amount,
        'organisationName': organisationName,
        'organisationTaxDeductible': organisationTaxDeductible,
        'isGiftAidEnabled': isGiftAidEnabled,
        'status': status.type.name,
        'timeStamp': timeStamp?.toIso8601String(),
        'mediumId': mediumId,
        'taxYear': taxYear,
        'donationType': donationType,
        'platformFeeTransactionId': platformFeeTransactionId,
        'platformFeeAmount': platformFeeAmount,
        'collectGroupId': collectGroupId,
        'collectId': collectId,
        'userId': userId,
    };
  }

  @override
  List<Object?> get props => [
        id,
        amount,
        organisationName,
        organisationTaxDeductible,
        isGiftAidEnabled,
        status,
        timeStamp,
        mediumId,
        taxYear,
        donationType,
        platformFeeTransactionId,
        platformFeeAmount,
        collectGroupId,
        collectId,
        userId,
      ];
}
