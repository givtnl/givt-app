/// Shared limits for manual donation amount entry in the Givt app.
///
/// Matches the numeric keyboard restrictions in the main giving flow.
class DonationAmountConstants {
  DonationAmountConstants._();

  /// Maximum digits before a decimal separator (comma or dot).
  static const int maxIntegerDigitsWithDecimal = 6;

  /// Maximum digits when no decimal separator is used.
  static const int maxIntegerDigits = 7;

  /// Highest supported donation amount for manual input.
  static const double maxInputAmount = 9999999;
}
