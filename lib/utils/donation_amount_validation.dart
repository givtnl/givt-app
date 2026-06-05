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

  static double parseLocalizedAmount(
    String value, {
    String decimalSeparator = ',',
  }) {
    return double.tryParse(value.replaceAll(decimalSeparator, '.')) ?? 0;
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

  /// Whether [amount] exceeds the user's configured per-donation maximum.
  static bool exceedsUserAmountLimit({
    required double amount,
    required int amountLimit,
  }) {
    return amount > 0 && amount > amountLimit;
  }

  /// Whether any parsed amount in [values] exceeds [amountLimit].
  static bool anyExceedsUserAmountLimit({
    required Iterable<String> values,
    required int amountLimit,
    String decimalSeparator = ',',
  }) {
    return values.any(
      (value) => exceedsUserAmountLimit(
        amount: parseLocalizedAmount(
          value,
          decimalSeparator: decimalSeparator,
        ),
        amountLimit: amountLimit,
      ),
    );
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
