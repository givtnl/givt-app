import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/datetime/api_date_time.dart';

void main() {
  group('ApiDateTime.parseLocal', () {
    test('uses wall-clock components from offset ISO strings', () {
      final local = ApiDateTime.parseLocal(
        '2026-05-30T18:50:17.5669885+00:00',
      );

      expect(local, isNotNull);
      expect(local!.isUtc, isFalse);
      expect(local.year, 2026);
      expect(local.month, 5);
      expect(local.day, 30);
      expect(local.hour, 18);
      expect(local.minute, 50);
    });

    test('Z suffix does not shift calendar day', () {
      expect(
        ApiDateTime.parseLocal('2024-06-01T00:00:00.000Z'),
        DateTime(2024, 6, 1),
      );
    });

    test('parses ISO without timezone offset', () {
      expect(
        ApiDateTime.parseLocal('2024-01-12T00:00:00.000'),
        DateTime(2024, 1, 12),
      );
    });

    test('returns null for empty input', () {
      expect(ApiDateTime.parseLocal(null), isNull);
      expect(ApiDateTime.parseLocal(''), isNull);
    });
  });

  group('ApiDateTime.formatYMMMd', () {
    test('formats using locale after converting to local time', () {
      final formatted = ApiDateTime.formatYMMMd(
        DateTime.utc(2026, 5, 30, 18, 50, 17),
        'en_US',
      );

      expect(formatted, contains('2026'));
    });
  });
}
