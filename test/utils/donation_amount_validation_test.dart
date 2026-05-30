import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/utils/donation_amount_validation.dart';

void main() {
  group('DonationAmountValidation', () {
    group('parseLocalizedAmount', () {
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

    group('exceedsUserAmountLimit', () {
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

    group('anyExceedsUserAmountLimit', () {
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
  });
}
