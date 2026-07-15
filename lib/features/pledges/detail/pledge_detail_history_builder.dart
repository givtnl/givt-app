import 'package:givt_app/features/pledges/detail/models/pledge_history_item.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';

abstract final class PledgeDetailHistoryBuilder {
  static List<PledgeHistoryItem> build({
    required PledgeGroup group,
    required DateTime now,
  }) {
    final items = <PledgeHistoryItem>[];
    final today = _dateOnly(now);

    final upcomingByDate = <DateTime, List<PledgeHistoryGoalLine>>{};
    for (final goal in group.goals) {
      for (final transaction in goal.transactions) {
        if (!transaction.isEntered) {
          continue;
        }
        final date = transaction.executionDateTime;
        if (date == null || _dateOnly(date).isBefore(today)) {
          continue;
        }
        final key = _dateOnly(date);
        upcomingByDate.putIfAbsent(key, () => []).add(
              PledgeHistoryGoalLine(
                goalName: goal.goalName,
                amount: transaction.amount,
              ),
            );
      }
    }

    if (upcomingByDate.isNotEmpty) {
      final upcomingDate = upcomingByDate.keys.reduce(
        (earliest, date) => date.isBefore(earliest) ? date : earliest,
      );
      items.add(
        PledgeHistoryItem(
          date: upcomingDate,
          isUpcoming: true,
          title: group.pledgeGroupName,
          goalLines: upcomingByDate[upcomingDate]!,
        ),
      );
    }

    final pastByDate = <DateTime, List<PledgeHistoryGoalLine>>{};
    for (final goal in group.goals) {
      if (goal.donations.isNotEmpty) {
        for (final donation in goal.donations) {
          if (!donation.isProcessed) {
            continue;
          }
          final date = donation.donationDateTime;
          if (date == null) {
            continue;
          }
          final key = _dateOnly(date);
          pastByDate.putIfAbsent(key, () => []).add(
                PledgeHistoryGoalLine(
                  goalName: goal.goalName,
                  amount: donation.amount,
                ),
              );
        }
        continue;
      }

      for (final transaction in goal.transactions) {
        if (!transaction.isProcessed) {
          continue;
        }
        final date = transaction.executionDateTime;
        if (date == null) {
          continue;
        }
        final key = _dateOnly(date);
        pastByDate.putIfAbsent(key, () => []).add(
              PledgeHistoryGoalLine(
                goalName: goal.goalName,
                amount: transaction.amount,
              ),
            );
      }
    }

    final pastDates = pastByDate.keys.toList()..sort((a, b) => b.compareTo(a));
    for (final date in pastDates) {
      items.add(
        PledgeHistoryItem(
          date: date,
          isUpcoming: false,
          title: group.pledgeGroupName,
          goalLines: pastByDate[date]!,
        ),
      );
    }

    return items;
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
