import 'package:equatable/equatable.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/models/transaction.dart';

class GivtTransaction extends Equatable {

  const GivtTransaction({
    required this.guid,
    required this.amount,
    required this.beaconId,
    required this.timestamp,
    required this.collectId,
    this.goalId,
    this.allocationName,
  }) : mediumId = beaconId;
  GivtTransaction.fromTransaction(Transaction transaction)
      : guid = transaction.userId,
        amount = transaction.amount,
        beaconId = transaction.mediumId,
        timestamp = transaction.timestamp,
        collectId = '1',
        goalId = transaction.goalId,
        mediumId = transaction.mediumId,
        allocationName = null;

  factory GivtTransaction.fromJson(Map<String, dynamic> json) {
    return GivtTransaction(
      guid: json.containsKey('Guid')
          ? json['Guid'] as String
          : json['UserId'] as String,
      amount: json['Amount'] as double,
      beaconId: json.containsKey('BeaconId')
          ? json['BeaconId'] as String
          : json['MediumId'] as String,
      timestamp: json['Timestamp'] as String,
      collectId: json['CollectId'] as String,
      goalId: (json['goalId'] ?? '') as String,
      allocationName: json['AllocationName'] as String?,
    );
  }

  final String guid;
  final double amount;
  final String beaconId;
  final String timestamp;
  final String collectId;
  final String mediumId;
  final String? goalId;
  final String? allocationName;

  /// The API contract for `submitGivts` must remain stable.
  Map<String, dynamic> toApiJson() {
    return <String, dynamic>{
      'Guid': guid,
      'Amount': amount,
      'BeaconId': beaconId,
      'Timestamp': timestamp,
      'CollectId': collectId,
      'mediumId': beaconId,
      'goalId': goalId,
    };
  }

  /// Web-only payload used by the confirm web page.
  Map<String, dynamic> toWebJson() {
    final out = <String, dynamic>{
      ...toApiJson(),
    };
    final trimmed = allocationName?.trim() ?? '';
    if (trimmed.isNotEmpty) {
      out['AllocationName'] = trimmed;
    }
    return out;
  }

  GivtTransaction copyWith({
    String? guid,
    double? amount,
    String? beaconId,
    String? timestamp,
    String? collectId,
    String? mediumId,
    String? goalId,
    String? allocationName,
  }) {
    return GivtTransaction(
      guid: guid ?? this.guid,
      amount: amount ?? this.amount,
      beaconId: beaconId ?? this.beaconId,
      timestamp: timestamp ?? this.timestamp,
      collectId: collectId ?? this.collectId,
      goalId: goalId ?? this.goalId,
      allocationName: allocationName ?? this.allocationName,
    );
  }

  static List<Map<String, dynamic>> toApiJsonList(
    List<GivtTransaction> transactionList,
  ) {
    return transactionList.map((transaction) => transaction.toApiJson()).toList();
  }

  static List<Map<String, dynamic>> toWebJsonList(
    List<GivtTransaction> transactionList,
  ) {
    return transactionList.map((transaction) => transaction.toWebJson()).toList();
  }

  static List<GivtTransaction> fromJsonList(
    List<dynamic> jsonList,
  ) {
    return jsonList
        .map(
          (json) => GivtTransaction.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  List<Object?> get props => [
        guid,
        amount,
        beaconId,
        timestamp,
        collectId,
        mediumId,
        goalId,
        allocationName,
      ];

  static const String givtTransactions = 'givtTransactions';
}
