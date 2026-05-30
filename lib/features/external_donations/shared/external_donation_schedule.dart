import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';

/// Computes the next occurrence date for a recurring external donation.
DateTime? computeNextOccurrenceDate({
  required DateTime startDate,
  required ExternalDonationFrequency frequency,
  required DateTime after,
}) {
  if (frequency == ExternalDonationFrequency.once) {
    return null;
  }

  var cursor = startDate;
  var guard = 0;
  while ((cursor.isBefore(after) || _isSameDay(cursor, after)) && guard < 500) {
    cursor = _addFrequency(cursor, frequency);
    guard++;
  }
  return cursor;
}

/// Preview of recurring occurrence dates for the create-flow confirm step.
///
/// Uses [lastGiftDate]'s day-of-month as the anchor for every period.
/// [startMonthYear] is the first month/year the user started giving (day 1 used
/// only to derive month/year; anchor day comes from [lastGiftDate]).
List<DateTime> generateOccurrencePreview({
  required DateTime startMonthYear,
  required DateTime lastGiftDate,
  required ExternalDonationFrequency frequency,
  DateTime? now,
}) {
  if (frequency == ExternalDonationFrequency.once) {
    return [lastGiftDate];
  }

  final anchorDay = lastGiftDate.day;
  var cursor = _dateWithAnchorDay(
    startMonthYear.year,
    startMonthYear.month,
    anchorDay,
  );
  final end = DateTime(
    lastGiftDate.year,
    lastGiftDate.month,
    lastGiftDate.day,
  );

  final occurrences = <DateTime>[];
  var guard = 0;
  while (!cursor.isAfter(end) && guard < 500) {
    occurrences.add(cursor);
    cursor = _addFrequency(cursor, frequency);
    guard++;
  }

  if (occurrences.isEmpty) {
    occurrences.add(lastGiftDate);
  }

  final reference = now ?? DateTime.now();
  final next = computeNextOccurrenceDate(
    startDate: occurrences.first,
    frequency: frequency,
    after: end.isAfter(reference) ? end : reference,
  );
  if (next != null && !occurrences.any((d) => _isSameDay(d, next))) {
    occurrences.add(next);
  }

  return occurrences;
}

DateTime _dateWithAnchorDay(int year, int month, int anchorDay) {
  final lastDay = DateTime(year, month + 1, 0).day;
  return DateTime(year, month, anchorDay.clamp(1, lastDay));
}

DateTime _addFrequency(
  DateTime date,
  ExternalDonationFrequency frequency,
) {
  switch (frequency) {
    case ExternalDonationFrequency.weekly:
      return date.add(const Duration(days: 7));
    case ExternalDonationFrequency.monthly:
      return _dateWithAnchorDay(date.year, date.month + 1, date.day);
    case ExternalDonationFrequency.quarterly:
      return _dateWithAnchorDay(date.year, date.month + 3, date.day);
    case ExternalDonationFrequency.halfYearly:
      return _dateWithAnchorDay(date.year, date.month + 6, date.day);
    case ExternalDonationFrequency.yearly:
      return _dateWithAnchorDay(date.year + 1, date.month, date.day);
    case ExternalDonationFrequency.once:
      return date;
  }
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Human-readable duration since [startDate] until [endDate] (inclusive days).
int givingDaysSince(DateTime startDate, DateTime endDate) {
  final days = endDate.difference(startDate).inDays;
  return days < 0 ? 0 : days;
}
