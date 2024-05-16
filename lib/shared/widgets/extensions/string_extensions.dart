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
}
