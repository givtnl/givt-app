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

  group('DonationAmountValidation.parseLocalizedAmount', () {
    test('parses comma decimal separator', () {
      expect(
        DonationAmountValidation.parseLocalizedAmount('12,50'),
        12.5,
      );
    });

    test('parses dot decimal separator', () {
      expect(
        DonationAmountValidation.parseLocalizedAmount(
          '12.50',
          decimalSeparator: '.',
        ),
        12.5,
      );
    });

    test('returns zero for invalid input', () {
      expect(DonationAmountValidation.parseLocalizedAmount(''), 0);
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

  group('DonationAmountValidation.exceedsUserAmountLimit', () {
    test('returns false for zero amount', () {
      expect(
        DonationAmountValidation.exceedsUserAmountLimit(
          amount: 0,
          amountLimit: 100,
        ),
        isFalse,
      );
    });

    test('returns false when amount equals limit', () {
      expect(
        DonationAmountValidation.exceedsUserAmountLimit(
          amount: 100,
          amountLimit: 100,
        ),
        isFalse,
      );
    });

    test('returns true when amount exceeds limit', () {
      expect(
        DonationAmountValidation.exceedsUserAmountLimit(
          amount: 101,
          amountLimit: 100,
        ),
        isTrue,
      );
    });
  });

  group('DonationAmountValidation.anyExceedsUserAmountLimit', () {
    test('returns false when all amounts are within limit', () {
      expect(
        DonationAmountValidation.anyExceedsUserAmountLimit(
          values: const ['0', '50', '100'],
          amountLimit: 100,
        ),
        isFalse,
      );
    });

    test('returns true when any amount exceeds limit', () {
      expect(
        DonationAmountValidation.anyExceedsUserAmountLimit(
          values: const ['0', '50,01'],
          amountLimit: 50,
        ),
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
