import 'package:equatable/equatable.dart';

class GivtTransaction extends Equatable {
  const GivtTransaction({
    required this.guid,
    required this.amount,
    required this.beaconId,
    required this.timestamp,
    required this.collectId,
  }) : mediumId = beaconId;

  factory GivtTransaction.fromJson(Map<String, dynamic> json) {
    return GivtTransaction(
      guid: json['Guid'] as String,
      amount: json['Amount'] as double,
      beaconId: json['BeaconId'] as String,
      timestamp: json['Timestamp'] as String,
      collectId: json['CollectId'] as String,
    );
  }

  final String guid;
  final double amount;
  final String beaconId;
  final String timestamp;
  final String collectId;
  final String mediumId;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Guid': guid,
      'Amount': amount,
      'BeaconId': beaconId,
      'Timestamp': timestamp,
      'CollectId': collectId,
      'mediumId': beaconId,
    };
  }

  GivtTransaction copyWith({
    String? guid,
    double? amount,
    String? beaconId,
    String? timestamp,
    String? collectId,
    String? mediumId,
  }) {
    return GivtTransaction(
      guid: guid ?? this.guid,
      amount: amount ?? this.amount,
      beaconId: beaconId ?? this.beaconId,
      timestamp: timestamp ?? this.timestamp,
      collectId: collectId ?? this.collectId,
    );
  }

  static List<Map<String, dynamic>> toJsonList(
    List<GivtTransaction> transactionList,
  ) {
    return transactionList.map((transaction) => transaction.toJson()).toList();
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
      ];

  static const String givtTransactions = 'givtTransactions';
}
