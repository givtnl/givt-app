import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/pledges/manage/utils/pledge_amount_validation.dart';

void main() {
  group('PledgeAmountValidation', () {
    test('isIncreaseOnly returns true when amount is higher', () {
      expect(
        PledgeAmountValidation.isIncreaseOnly(
          currentAmount: 150,
          input: '200',
        ),
        isTrue,
      );
    });

    test('isIncreaseOnly returns false when amount is equal', () {
      expect(
        PledgeAmountValidation.isIncreaseOnly(
          currentAmount: 150,
          input: '150',
        ),
        isFalse,
      );
    });

    test('isIncreaseOnly returns false when amount is lower', () {
      expect(
        PledgeAmountValidation.isIncreaseOnly(
          currentAmount: 150,
          input: '100',
        ),
        isFalse,
      );
    });

    test('canSave requires positive increase and changed input', () {
      expect(
        PledgeAmountValidation.canSave(
          currentAmount: 150,
          input: '200',
          initialInput: '150',
        ),
        isTrue,
      );
      expect(
        PledgeAmountValidation.canSave(
          currentAmount: 150,
          input: '150',
          initialInput: '150',
        ),
        isFalse,
      );
      expect(
        PledgeAmountValidation.canSave(
          currentAmount: 150,
          input: '100',
          initialInput: '150',
        ),
        isFalse,
      );
    });
  });
}
