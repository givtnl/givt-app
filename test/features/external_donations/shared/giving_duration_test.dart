import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';

void main() {
  group('givingDurationBetween', () {
    test('returns days for periods under one month', () {
      final start = DateTime(2024, 6, 1);
      final end = DateTime(2024, 6, 15);

      final duration = givingDurationBetween(start, end);

      expect(duration.unit, GivingDurationUnit.days);
      expect(duration.value, 14);
    });

    test('returns at least 1 day when start and end are the same day', () {
      final day = DateTime(2024, 6, 1);

      final duration = givingDurationBetween(day, day);

      expect(duration.unit, GivingDurationUnit.days);
      expect(duration.value, 1);
    });

    test('returns months for periods under one year', () {
      final start = DateTime(2024, 1, 15);
      final end = DateTime(2024, 4, 14);

      final duration = givingDurationBetween(start, end);

      expect(duration.unit, GivingDurationUnit.months);
      expect(duration.value, 2);
    });

    test('returns years for periods of one year or more', () {
      final start = DateTime(2022, 3, 10);
      final end = DateTime(2024, 3, 9);

      final duration = givingDurationBetween(start, end);

      expect(duration.unit, GivingDurationUnit.years);
      expect(duration.value, 1);
    });

    test('returns multiple years for long periods', () {
      final start = DateTime(2020, 1, 1);
      final end = DateTime(2024, 6, 1);

      final duration = givingDurationBetween(start, end);

      expect(duration.unit, GivingDurationUnit.years);
      expect(duration.value, 4);
    });
  });
}
