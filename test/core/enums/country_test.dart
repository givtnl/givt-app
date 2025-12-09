import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/country.dart';

void main() {
  group('Country.fromPrefix', () {
    test('returns matching country for known prefix', () {
      expect(Country.fromPrefix('+44'), Country.gb);
    });

    test('falls back to provided country when prefix is unknown', () {
      const fallback = Country.nl;
      expect(
        Country.fromPrefix('+999', fallback: fallback),
        fallback,
      );
    });
  });
}
