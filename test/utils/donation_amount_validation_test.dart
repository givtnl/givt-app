import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/constants/donation_amount_constants.dart';
import 'package:givt_app/utils/donation_amount_validation.dart';

void main() {
  group('DonationAmountValidation.parseAmount', () {
    test('parses comma and dot decimal separators', () {
      expect(DonationAmountValidation.parseAmount('12,50'), 12.5);
      expect(DonationAmountValidation.parseAmount('12.50'), 12.5);
    });
  });

  group('DonationAmountValidation.exceedsMaxInputAmount', () {
    test('returns false for valid amounts', () {
      expect(DonationAmountValidation.exceedsMaxInputAmount('5'), isFalse);
      expect(
        DonationAmountValidation.exceedsMaxInputAmount(
          DonationAmountConstants.maxInputAmount.toString(),
        ),
        isFalse,
      );
    });

    test('returns true for extremely large amounts', () {
      expect(
        DonationAmountValidation.exceedsMaxInputAmount('9999999999'),
        isTrue,
      );
    });
  });

  group('DonationAmountValidation keyboard helpers', () {
    test('limits integer digits to seven', () {
      var text = '999999';
      text = DonationAmountValidation.appendDigit(
        currentText: text,
        digit: '9',
        decimalSeparator: ',',
      );
      expect(text, '9999999');

      text = DonationAmountValidation.appendDigit(
        currentText: text,
        digit: '9',
        decimalSeparator: ',',
      );
      expect(text, '9999999');
    });

    test('allows two decimal digits after separator', () {
      var text = DonationAmountValidation.appendDecimalSeparator(
        currentText: '999999',
        decimalSeparator: ',',
      );
      expect(text, '999999,');

      text = DonationAmountValidation.appendDigit(
        currentText: text,
        digit: '9',
        decimalSeparator: ',',
      );
      text = DonationAmountValidation.appendDigit(
        currentText: text,
        digit: '9',
        decimalSeparator: ',',
      );
      expect(text, '999999,99');

      text = DonationAmountValidation.appendDigit(
        currentText: text,
        digit: '9',
        decimalSeparator: ',',
      );
      expect(text, '999999,99');
    });
  });
}
