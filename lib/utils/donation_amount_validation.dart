import 'package:givt_app/core/constants/donation_amount_constants.dart';

/// Validation and input helpers for donation amount fields.
class DonationAmountValidation {
  DonationAmountValidation._();

  static double? parseAmount(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return double.tryParse(normalized.replaceAll(',', '.'));
  }

  static bool exceedsMaxInputAmount(String value) {
    final amount = parseAmount(value);
    if (amount == null) {
      return false;
    }
    return amount > DonationAmountConstants.maxInputAmount;
  }

  static bool isPositiveWithinInputLimit(String value) {
    final amount = parseAmount(value);
    if (amount == null || amount <= 0) {
      return false;
    }
    return amount <= DonationAmountConstants.maxInputAmount;
  }

  /// Applies the same digit restrictions as the main giving numeric keyboard.
  static String appendDigit({
    required String currentText,
    required String digit,
    required String decimalSeparator,
    String zeroChar = '0',
  }) {
    if (currentText.contains(decimalSeparator)) {
      final parts = currentText.split(decimalSeparator);
      if (parts.length > 1 && parts[1].length >= 2) {
        return currentText;
      }
      return currentText + digit;
    }

    if (currentText == zeroChar) {
      return digit;
    }

    if (currentText.length >= DonationAmountConstants.maxIntegerDigits) {
      return currentText;
    }

    return currentText + digit;
  }

  /// Applies the same decimal-separator restrictions as the main giving flow.
  static String appendDecimalSeparator({
    required String currentText,
    required String decimalSeparator,
    String zeroChar = '0',
  }) {
    if (currentText.contains(decimalSeparator)) {
      return currentText;
    }

    if (currentText.length >
        DonationAmountConstants.maxIntegerDigitsWithDecimal) {
      return currentText;
    }

    if (currentText == zeroChar) {
      return '$zeroChar$decimalSeparator';
    }

    return '$currentText$decimalSeparator';
  }
}
