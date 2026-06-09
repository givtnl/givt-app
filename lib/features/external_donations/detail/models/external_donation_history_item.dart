class ExternalDonationHistoryItem {
  const ExternalDonationHistoryItem({
    required this.amount,
    required this.date,
    required this.isUpcoming,
    this.transactionId,
  });

  final String? transactionId;
  final double amount;
  final DateTime date;
  final bool isUpcoming;

  bool get isSelectable =>
      !isUpcoming && transactionId != null && transactionId!.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExternalDonationHistoryItem &&
        other.transactionId == transactionId &&
        other.amount == amount &&
        other.date == date &&
        other.isUpcoming == isUpcoming;
  }

  @override
  int get hashCode => Object.hash(transactionId, amount, date, isUpcoming);
}
