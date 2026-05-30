/// Validation helpers for donation amount fields.
class DonationAmountValidation {
  DonationAmountValidation._();

  static double parseLocalizedAmount(
    String value, {
    String decimalSeparator = ',',
  }) {
    return double.tryParse(value.replaceAll(decimalSeparator, '.')) ?? 0;
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
}
