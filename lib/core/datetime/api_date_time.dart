import 'package:intl/intl.dart';

/// Parsing and display helpers for API timestamps (C# [DateTimeOffset] / ISO-8601).
abstract final class ApiDateTime {
  /// Parses [raw] and returns the instant in the device's local timezone.
  static DateTime? parseLocal(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final parsed = DateTime.tryParse(raw);
    return parsed?.toLocal();
  }

  /// Locale-formatted calendar date in local time (e.g. "May 30, 2026").
  static String formatYMMMd(DateTime? date, String locale) {
    if (date == null) {
      return '';
    }
    return DateFormat.yMMMd(locale).format(date.toLocal());
  }
}
