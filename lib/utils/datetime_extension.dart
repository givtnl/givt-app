import 'package:givt_app/l10n/l10n.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatDate(AppLocalizations locals) {
    final now = DateTime.now();

    // Check if the date is today
    if (year == now.year && month == now.month && day == now.day) {
      return locals.today;
    }

    // Check if the date is yesterday
    final yesterday = now.subtract(const Duration(days: 1));
    if (year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day) {
      return locals.yesterday;
    }

    final formatter = DateFormat('MM/dd');

    return formatter.format(this);
  }
}
