import 'package:equatable/equatable.dart';

/// Item payload from `POST /givtservice/v1/Mandates/bacs`.
class BacsMandateResponse extends Equatable {
  const BacsMandateResponse({
    required this.sortCode,
    required this.accountNumber,
    this.mandateStatus,
  });

  factory BacsMandateResponse.fromJson(Map<String, dynamic> json) {
    return BacsMandateResponse(
      sortCode: (json['sortCode'] ?? '') as String,
      accountNumber: (json['accountNumber'] ?? '') as String,
      mandateStatus: json['mandateStatus'] as String?,
    );
  }

  final String sortCode;
  final String accountNumber;
  final String? mandateStatus;

  @override
  List<Object?> get props => [sortCode, accountNumber, mandateStatus];
}
