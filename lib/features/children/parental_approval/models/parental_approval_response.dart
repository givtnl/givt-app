import 'package:equatable/equatable.dart';

class ParentalApprovalResponse extends Equatable {
  const ParentalApprovalResponse({
    required this.isError,
    required this.errorMessage,
    required this.detailResponse,
  });

  factory ParentalApprovalResponse.fromMap(Map<String, dynamic> map) {
    final holder = map['item'] as Map<String, dynamic>;
    return ParentalApprovalResponse(
      isError: map['isError'] as bool,
      errorMessage: map['errorMessage'] as String,
      detailResponse: DetailResponse.fromMap(
        holder['transactionDetail'] as Map<String, dynamic>,
      ),
    );
  }

  final bool isError;
  final String errorMessage;
  final DetailResponse detailResponse;

  @override
  List<Object> get props => [
        isError,
        errorMessage,
        detailResponse,
      ];
}

class DetailResponse extends Equatable {
  const DetailResponse({
    required this.userId,
    required this.amount,
    required this.donationDate,
    required this.status,
  });

  factory DetailResponse.fromMap(Map<String, dynamic> map) {
    return DetailResponse(
      userId: map['userId'] as String,
      amount: map['amount'] as double,
      donationDate: map['donationDate'] as String,
      status: map['status'] as String,
    );
  }

  final String userId;
  final double amount;
  final String donationDate;
  final String status;

  @override
  List<Object?> get props => [userId, amount, donationDate, status];
}
