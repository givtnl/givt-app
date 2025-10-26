import 'package:intl/intl.dart';

class Transaction {
  Transaction({
    required this.userId,
    required this.mediumId,
    required this.amount,
    this.goalId,
    this.isActOfService = false,
    this.gameGuid,
    this.searchText,
  }) : timestamp =
            DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now().toUtc());

  final String userId;
  final String mediumId;
  final double amount;
  final String? goalId;
  final bool isActOfService;
  final String? gameGuid;
  final String? searchText;
  final String timestamp;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'mediumId': mediumId,
      'amount': amount,
      'goalId': goalId,
      'timestamp': timestamp,
      'isActOfService': isActOfService,
      if (gameGuid != null) 'GameId': gameGuid,
      if (searchText != null && searchText!.isNotEmpty) 'searchText': searchText,
    };
  }
}
