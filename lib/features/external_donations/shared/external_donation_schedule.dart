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

DateTime _addFrequency(
  DateTime date,
  ExternalDonationFrequency frequency,
) {
  switch (frequency) {
    case ExternalDonationFrequency.monthly:
      return DateTime(date.year, date.month + 1, date.day);
    case ExternalDonationFrequency.quarterly:
      return DateTime(date.year, date.month + 3, date.day);
    case ExternalDonationFrequency.halfYearly:
      return DateTime(date.year, date.month + 6, date.day);
    case ExternalDonationFrequency.yearly:
      return DateTime(date.year + 1, date.month, date.day);
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
