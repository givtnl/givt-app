import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/utils/util.dart';

void main() {
  group('Util.formatUkPostCode', () {
    test('returns null for empty input', () {
      expect(Util.formatUkPostCode(''), isNull);
      expect(Util.formatUkPostCode(null), isNull);
    });

    test('keeps already formatted postcode', () {
      expect(Util.formatUkPostCode('SW1A 1AA'), equals('SW1A 1AA'));
    });

    test('inserts missing space for valid postcode', () {
      expect(Util.formatUkPostCode('SW1A1AA'), equals('SW1A 1AA'));
      expect(Util.formatUkPostCode('m11aa'), equals('M1 1AA'));
    });

    test('normalizes multiple spaces and casing', () {
      expect(Util.formatUkPostCode(' sw1a   1aa '), equals('SW1A 1AA'));
    });

    test('returns null for invalid postcode', () {
      expect(Util.formatUkPostCode('INVALID'), isNull);
      expect(Util.formatUkPostCode('SW1A 1A'), isNull);
    });
  });
}
