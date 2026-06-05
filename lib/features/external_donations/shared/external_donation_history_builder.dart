import 'package:givt_app/features/external_donations/detail/models/external_donation_history_item.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_transaction.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
/// Builds recurring external-donation history for the detail screen.
abstract final class ExternalDonationHistoryBuilder {
  const ExternalDonationHistoryBuilder._();

  static RecurringExternalDonationDetail build({
    required ExternalDonation donation,
    required List<ExternalDonationTransaction> transactions,
    required DateTime now,
  }) {
    final seriesStartDate = donation.startDateTime;
    var recorded = _recordedTransactions(transactions, now);

    if (recorded.isEmpty && seriesStartDate != null) {
      recorded.add(
        ExternalDonationHistoryItem(
          amount: donation.amount,
          date: seriesStartDate,
          isUpcoming: false,
        ),
      );
    }

    final totalDonated = recorded.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    GivingDuration? givingDuration;
    if (recorded.isNotEmpty) {
      final firstGivingDate = recorded.last.date;
      final lastGivingDate = recorded.first.date;
      final givingEndDate =
          donation.active ? now : lastGivingDate;
      givingDuration =
          givingDurationBetween(firstGivingDate, givingEndDate);
    }

    var history = recorded;
    if (donation.active) {
      final nextDate = donation.nextRecurringOccurrenceDate ??
          (seriesStartDate != null
              ? computeNextOccurrenceDate(
                  startDate: seriesStartDate,
                  frequency: donation.frequency,
                  after: now,
                )
              : null);
      if (nextDate != null) {
        history = [
          ExternalDonationHistoryItem(
            amount: donation.amount,
            date: nextDate,
            isUpcoming: true,
          ),
          ...recorded,
        ];
      }
    }

    return RecurringExternalDonationDetail(
      totalDonated: totalDonated,
      givingDuration: givingDuration,
      history: history,
    );
  }

  static List<ExternalDonationHistoryItem> _recordedTransactions(
    List<ExternalDonationTransaction> transactions,
    DateTime now,
  ) {
    final recorded = <ExternalDonationHistoryItem>[];
    for (final transaction in transactions) {
      final date = transaction.occurredAt;
      if (date == null || date.isAfter(now)) {
        continue;
      }
      recorded.add(
        ExternalDonationHistoryItem(
          amount: transaction.amount,
          date: date,
          isUpcoming: false,
        ),
      );
    }
    recorded.sort((a, b) => b.date.compareTo(a.date));
    return recorded;
  }
}

/// Aggregated recurring detail data for [ExternalDonationDetailRepository].
class RecurringExternalDonationDetail {
  const RecurringExternalDonationDetail({
    required this.totalDonated,
    required this.givingDuration,
    required this.history,
  });

  final double totalDonated;
  final GivingDuration? givingDuration;
  final List<ExternalDonationHistoryItem> history;
}
