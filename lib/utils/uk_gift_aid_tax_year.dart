import 'package:intl/intl.dart';

/// UK Gift Aid tax year index (same rule as `Givt.fromJson` / donation `taxYear`).
///
/// April 6–April 5 boundaries: on or before April 5 → previous calendar year
/// index.
int ukGiftAidTaxYearIndexForDate(DateTime timestamp) {
  final month = int.parse(DateFormat('M').format(timestamp));
  final day = int.parse(DateFormat('d').format(timestamp));
  var taxYear = int.parse(DateFormat('yyyy').format(timestamp));
  if (month <= 3 || (month == 4 && day <= 5)) {
    taxYear -= 1;
  }
  return taxYear;
}

/// Display label year used in copy such as "tax year 2026" (end year of the TY
/// window).
int ukGiftAidTaxYearDisplayYear(DateTime date) =>
    ukGiftAidTaxYearIndexForDate(date) + 1;
