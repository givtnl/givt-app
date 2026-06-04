import 'package:intl/intl.dart';

/// Parsing and display helpers for API date/time strings (ISO-8601).
abstract final class ApiDateTime {
  /// Parses [raw] as local wall-clock date/time without a timezone offset shift.
  ///
  /// External-donation API values are calendar date/times as the user entered
  /// them. Any `Z` or `+00:00` suffix is ignored for display; only the
  /// date/time components are used.
  static DateTime? parseLocal(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return null;
    }
    return DateTime(
      parsed.year,
      parsed.month,
      parsed.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
      parsed.millisecond,
      parsed.microsecond,
    );
  }

  /// Locale-formatted calendar date (e.g. "May 30, 2026").
  static String formatYMMMd(DateTime? date, String locale) {
    if (date == null) {
      return '';
    }
    return DateFormat.yMMMd(locale).format(date.toLocal());
  }
}
