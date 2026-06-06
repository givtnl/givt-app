import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/utils/util.dart';

void main() {
  group('splitNetherlandsAddress', () {
    test('splits street and house number when last token has a digit', () {
      final result = Util.splitNetherlandsAddress('Bongerd 1');

      expect(result.street, 'Bongerd');
      expect(result.houseNumber, '1');
    });

    test('returns full address as street when no house number pattern', () {
      final result = Util.splitNetherlandsAddress('Main Street');

      expect(result.street, 'Main Street');
      expect(result.houseNumber, '');
    });
  });

  group('combineNetherlandsAddress', () {
    test('joins street and house number with a space', () {
      expect(
        Util.combineNetherlandsAddress(
          street: 'Bongerd',
          houseNumber: '1',
        ),
        'Bongerd 1',
      );
    });

    test('returns street only when house number is empty', () {
      expect(
        Util.combineNetherlandsAddress(
          street: 'Main Street',
          houseNumber: '',
        ),
        'Main Street',
      );
    });
  });
}
