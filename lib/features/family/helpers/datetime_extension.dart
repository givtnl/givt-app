import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatDate() {
    DateTime now = DateTime.now();

    // Check if the date is today
    if (year == now.year && month == now.month && day == now.day) {
      return 'Today';
    }

    // Check if the date is yesterday
    DateTime yesterday = now.subtract(const Duration(days: 1));
    if (year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day) {
      return 'Yesterday';
    }

    final formatter = DateFormat('MM/dd');
    return formatter.format(this);
  }

  String get formattedFullUSDate {
    final formatter = DateFormat('MM/dd/yyyy');
    return formatter.format(this);
  }

  String get formattedFullEuDate {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(this);
  }
}
