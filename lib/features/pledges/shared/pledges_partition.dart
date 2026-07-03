import 'package:givt_app/features/pledges/shared/models/pledge.dart';

/// Splits pledges into Current vs Past tabs by goal end date.
class PledgesPartition {
  const PledgesPartition._();

  /// Past when the pledge campaign [Pledge.endDate] is strictly before today.
  ///
  /// Pledges without an end date stay on the Current tab.
  static bool isPast(Pledge pledge, {DateTime? now}) {
    final endDate = pledge.endDateTime;
    if (endDate == null) {
      return false;
    }
    return _dateOnly(endDate).isBefore(_dateOnly(now ?? DateTime.now()));
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
