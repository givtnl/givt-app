import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';

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

/// Last scheduled occurrence on or before [onOrBefore], walking forward from
/// [seriesStartDate] with [frequency].
DateTime occurrenceSeriesEndDate({
  required DateTime seriesStartDate,
  required ExternalDonationFrequency frequency,
  required DateTime onOrBefore,
}) {
  if (frequency == ExternalDonationFrequency.once) {
    return seriesStartDate;
  }

  final onOrBeforeDay = DateTime(
    onOrBefore.year,
    onOrBefore.month,
    onOrBefore.day,
  );
  var cursor = DateTime(
    seriesStartDate.year,
    seriesStartDate.month,
    seriesStartDate.day,
  );
  var lastOnOrBefore = cursor;
  var guard = 0;
  while (!cursor.isAfter(onOrBeforeDay) && guard < 500) {
    lastOnOrBefore = cursor;
    cursor = _addFrequency(cursor, frequency);
    guard++;
  }

  return lastOnOrBefore;
}

/// Preview of recurring occurrence dates for the create-flow confirm step.
///
/// Past occurrences run through the latest scheduled date on or before [now],
/// plus one upcoming occurrence when applicable.
List<DateTime> generateOccurrencePreview({
  required DateTime seriesStartDate,
  required ExternalDonationFrequency frequency,
  DateTime? now,
}) {
  if (frequency == ExternalDonationFrequency.once) {
    return [seriesStartDate];
  }

  var cursor = DateTime(
    seriesStartDate.year,
    seriesStartDate.month,
    seriesStartDate.day,
  );
  final reference = now ?? DateTime.now();
  final today = DateTime(reference.year, reference.month, reference.day);
  final end = occurrenceSeriesEndDate(
    seriesStartDate: seriesStartDate,
    frequency: frequency,
    onOrBefore: today,
  );

  final occurrences = <DateTime>[];
  var guard = 0;
  while (!cursor.isAfter(end) && guard < 500) {
    occurrences.add(cursor);
    cursor = _addFrequency(cursor, frequency);
    guard++;
  }

  if (occurrences.isEmpty) {
    occurrences.add(seriesStartDate);
  }

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

enum GivingDurationUnit { days, months, years }

/// A giving period length for display (e.g. "3 months", "2 years").
class GivingDuration {
  const GivingDuration(this.value, this.unit);

  final int value;
  final GivingDurationUnit unit;
}

/// Picks days, months, or years based on calendar distance between [startDate] and [endDate].
GivingDuration givingDurationBetween(DateTime startDate, DateTime endDate) {
  final start = DateTime(startDate.year, startDate.month, startDate.day);
  final end = DateTime(endDate.year, endDate.month, endDate.day);

  final years = _calendarYearsBetween(start, end);
  if (years >= 1) {
    return GivingDuration(years, GivingDurationUnit.years);
  }

  final months = _calendarMonthsBetween(start, end);
  if (months >= 1) {
    return GivingDuration(months, GivingDurationUnit.months);
  }

  final days = givingDaysSince(start, end);
  return GivingDuration(days < 1 ? 1 : days, GivingDurationUnit.days);
}

int _calendarYearsBetween(DateTime start, DateTime end) {
  var years = end.year - start.year;
  if (end.month < start.month ||
      (end.month == start.month && end.day < start.day)) {
    years--;
  }
  return years < 0 ? 0 : years;
}

int _calendarMonthsBetween(DateTime start, DateTime end) {
  var months = (end.year - start.year) * 12 + end.month - start.month;
  if (end.day < start.day) {
    months--;
  }
  return months < 0 ? 0 : months;
}
