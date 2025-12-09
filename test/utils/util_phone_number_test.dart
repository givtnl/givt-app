import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/utils/util.dart';

void main() {
  group('Util.normalizePhoneNumber', () {
    test('removes leading zero for European countries', () {
      final normalized = Util.normalizePhoneNumber(
        country: Country.nl,
        phoneNumber: '0612345678',
      );

      expect(normalized, '612345678');
    });

    test('preserves leading zero for US numbers', () {
      final normalized = Util.normalizePhoneNumber(
        country: Country.us,
        phoneNumber: '0123456789',
      );

      expect(normalized, '0123456789');
    });

    test('removes whitespace before processing', () {
      final normalized = Util.normalizePhoneNumber(
        country: Country.gb,
        phoneNumber: ' 07 1234 56789 ',
      );

      expect(normalized, '7123456789');
    });
  });

  group('Util.formatPhoneNumberWithPrefix', () {
    test('strips leading zero when combining prefix', () {
      final formatted = Util.formatPhoneNumberWithPrefix(
        country: Country.gb,
        phoneNumber: '07123456789',
      );

      expect(formatted, '+447123456789');
    });

    test('leaves number untouched when zero not provided', () {
      final formatted = Util.formatPhoneNumberWithPrefix(
        country: Country.gb,
        phoneNumber: '7123456789',
      );

      expect(formatted, '+447123456789');
    });
  });
}
