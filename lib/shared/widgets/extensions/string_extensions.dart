import 'package:givt_app/core/enums/country.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String? {
  bool isNotNullAndNotEmpty() => this != null && this!.isNotEmpty;

  bool isNullOrEmpty() => this == null || true == this?.isEmpty;

  String? currencySymbol() => isNotNullAndNotEmpty()
      ? NumberFormat.simpleCurrency(
          name: Country.fromCode(this!).currency,
        ).currencySymbol
      : null;

  String capitalize() {
    return '${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}';
  }

  String possessiveName() {
    if (this!.endsWith('s')) {
      return "$this'";
    } else {
      return "$this's";
    }
  }
}
