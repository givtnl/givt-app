import 'package:givt_app/l10n/l10n.dart';
import 'package:intl/intl.dart';

extension StringDateTimeExtension on String {
  String formatDate(AppLocalizations locals) {
    final date = DateTime.tryParse(this) ?? DateTime.now();

    final now = DateTime.now();

    // Check if the date is today
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return locals.today;
    }

    // Check if the date is yesterday
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return locals.yesterday;
    }

    final formatter = DateFormat('MM/dd');

    return formatter.format(date);
  }
}
