import 'package:givt_app/utils/donation_amount_validation.dart';

abstract final class PledgeAmountValidation {
  static bool isIncreaseOnly({
    required double currentAmount,
    required String input,
  }) {
    final parsed = DonationAmountValidation.parseAmount(input);
    if (parsed == null) {
      return false;
    }
    return parsed > currentAmount;
  }

  static bool canSave({
    required double currentAmount,
    required String input,
    required String initialInput,
  }) {
    if (!DonationAmountValidation.isPositiveWithinInputLimit(input)) {
      return false;
    }
    if (input.trim() == initialInput.trim()) {
      return false;
    }
    return isIncreaseOnly(currentAmount: currentAmount, input: input);
  }
}
