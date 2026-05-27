import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/utils/uk_gift_aid_tax_year.dart';

void main() {
  group('ukGiftAidTaxYearIndexForDate', () {
    test('6 April belongs to the new tax year (same calendar year index)', () {
      expect(
        ukGiftAidTaxYearIndexForDate(DateTime.utc(2025, 4, 6)),
        2025,
      );
    });

    test('5 April belongs to the previous tax year index', () {
      expect(
        ukGiftAidTaxYearIndexForDate(DateTime.utc(2025, 4, 5)),
        2024,
      );
    });

    test('dates before 6 April use previous calendar year as index', () {
      expect(
        ukGiftAidTaxYearIndexForDate(DateTime.utc(2025, 3, 31)),
        2024,
      );
    });

    test('1 January uses previous calendar year as index', () {
      expect(
        ukGiftAidTaxYearIndexForDate(DateTime.utc(2026, 1, 15)),
        2025,
      );
    });
  });

  group('ukGiftAidTaxYearDisplayYear', () {
    test('display year is index + 1', () {
      expect(
        ukGiftAidTaxYearDisplayYear(DateTime.utc(2025, 4, 6)),
        2026,
      );
    });
  });
}
