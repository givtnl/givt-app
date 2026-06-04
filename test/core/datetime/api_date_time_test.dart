import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/datetime/api_date_time.dart';

void main() {
  group('ApiDateTime.parseLocal', () {
    test('parses C# DateTimeOffset with fractional seconds', () {
      final local = ApiDateTime.parseLocal(
        '2026-05-30T18:50:17.5669885+00:00',
      );

      expect(local, isNotNull);
      expect(local!.isUtc, isFalse);
      expect(
        local,
        DateTime.parse('2026-05-30T18:50:17.5669885+00:00').toLocal(),
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
