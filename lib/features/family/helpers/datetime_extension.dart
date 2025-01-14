import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Formats with 'Today' and 'Yesterday' otherwise
  /// Formats the date in the format 'MM/dd'
  String formatInlineDate() {
    final now = DateTime.now();

    // Check if the date is today
    if (year == now.year && month == now.month && day == now.day) {
      return 'Today';
    }

    // Check if the date is yesterday
    final yesterday = now.subtract(const Duration(days: 1));
    if (year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day) {
      return 'Yesterday';
    }

    final formatter = DateFormat('MM/dd');
    return formatter.format(this);
  }

  /// Formats the date like 'December 16'
  String get formattedFullMonth {
    final formatter = DateFormat.MMMMd();
    return formatter.format(this);
  }

  /// Formats the date for US like '04/30/2022' == 'MM/dd/yyyy'
  String get formattedFullUSDate {
    final formatter = DateFormat('MM/dd/yyyy');
    return formatter.format(this);
  }

  /// Formats the date for EU like '31/08/2022' == 'dd/MM/yyyy'
  String get formattedFullEuDate {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(this);
  }
}
