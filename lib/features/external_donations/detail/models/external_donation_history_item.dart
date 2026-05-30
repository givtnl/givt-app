class ExternalDonationHistoryItem {
  const ExternalDonationHistoryItem({
    required this.amount,
    required this.date,
    required this.isUpcoming,
  });

  final double amount;
  final DateTime date;
  final bool isUpcoming;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExternalDonationHistoryItem &&
        other.amount == amount &&
        other.date == date &&
        other.isUpcoming == isUpcoming;
  }

  @override
  int get hashCode => Object.hash(amount, date, isUpcoming);
}
