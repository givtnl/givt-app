import 'package:equatable/equatable.dart';

class Givt extends Equatable {
  const Givt({
    required this.id,
    required this.amount,
    required this.collectGroupId,
    required this.organisationName,
    required this.organisationTaxDeductible,
    required this.collectId,
    required this.isGiftAid,
    required this.status,
    required this.timeStamp,
    required this.mediumId,
  });

  const Givt.empty()
      : id = 0,
        amount = 0,
        collectGroupId = '',
        organisationName = '',
        organisationTaxDeductible = false,
        collectId = '',
        isGiftAid = false,
        status = 0,
        timeStamp = '',
        mediumId = '';

  factory Givt.fromJson(Map<String, dynamic> json) => Givt(
        id: json['Id'] as int,
        amount: json['Amount'] as double,
        collectGroupId: json['CollectGroupId'] as String,
        organisationName: json['OrgName'] as String,
        organisationTaxDeductible: json['OrganisationTaxDeductible'] as bool,
        collectId: json['CollectId'] as String,
        isGiftAid: json['GiftAidEnabled'] as bool,
        status: json['Status'] as int,
        timeStamp: json['TimeStamp'] as String,
        mediumId: json['MediumId'] as String,
      );

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
  final String collectId;
  final bool isGiftAid;
  final int status;
  final String timeStamp;
  final String mediumId;

  Givt copyWith({
    int? id,
    double? amount,
    String? collectGroupId,
    String? organisationName,
    bool? organisationTaxDeductible,
    String? collectId,
    bool? isGiftAid,
    int? status,
    String? timeStamp,
    String? mediumId,
  }) =>
      Givt(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        collectGroupId: collectGroupId ?? this.collectGroupId,
        organisationName: organisationName ?? this.organisationName,
        organisationTaxDeductible:
            organisationTaxDeductible ?? this.organisationTaxDeductible,
        collectId: collectId ?? this.collectId,
        isGiftAid: isGiftAid ?? this.isGiftAid,
        status: status ?? this.status,
        timeStamp: timeStamp ?? this.timeStamp,
        mediumId: mediumId ?? this.mediumId,
      );

  @override
  List<Object?> get props => [
        id,
        amount,
        collectGroupId,
        organisationName,
        organisationTaxDeductible,
        collectId,
        isGiftAid,
        status,
        timeStamp,
        mediumId,
      ];
}
