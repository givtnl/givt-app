import 'package:givt_app/core/datetime/api_date_time.dart';

class ExternalDonationTransaction {
  const ExternalDonationTransaction({
    required this.id,
    required this.amount,
    required this.creationDate,
  });

  factory ExternalDonationTransaction.fromJson(Map<String, dynamic> json) {
    return ExternalDonationTransaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      creationDate: json['creationDate'] as String,
    );
  }

  final String id;
  final double amount;
  final String creationDate;

  /// When the transaction occurred, in local time.
  DateTime? get occurredAt => ApiDateTime.parseLocal(creationDate);

  static List<ExternalDonationTransaction> fromJsonList(List<dynamic> json) {
    return json
        .map(
          (item) => ExternalDonationTransaction.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
