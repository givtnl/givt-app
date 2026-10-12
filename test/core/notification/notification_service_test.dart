import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/notification/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
  });

  group('summaryNotificationNeedsScheduling', () {
    test('schedules when there is no previous date', () {
      final proposed = tz.TZDateTime(tz.local, 2026, 11, 25, 20);

      expect(
        NotificationService.summaryNotificationNeedsScheduling(
          lastScheduled: null,
          proposedScheduleDate: proposed,
        ),
        isTrue,
      );
    });

    test('skips when the same period was already scheduled', () {
      final proposed = tz.TZDateTime(tz.local, 2026, 11, 25, 20);

      expect(
        NotificationService.summaryNotificationNeedsScheduling(
          lastScheduled: proposed,
          proposedScheduleDate: proposed,
        ),
        isFalse,
      );
    });

    test('schedules when a new period starts', () {
      final last = tz.TZDateTime(tz.local, 2026, 10, 25, 20);
      final proposed = tz.TZDateTime(tz.local, 2026, 11, 25, 20);

      expect(
        NotificationService.summaryNotificationNeedsScheduling(
          lastScheduled: last,
          proposedScheduleDate: proposed,
        ),
        isTrue,
      );
    });
  });

  group('isNotificationSchedulingNotAuthorized', () {
    test('detects PlatformException code 2003', () {
      expect(
        isNotificationSchedulingNotAuthorized(
          PlatformException(code: '2003', message: 'Source is not authorized.'),
        ),
        isTrue,
      );
    });

    test('detects not authorized message', () {
      expect(
        isNotificationSchedulingNotAuthorized(
          PlatformException(
            code: 'error',
            message: 'Source is not authorized.',
          ),
        ),
        isTrue,
      );
    });

    test('returns false for unrelated errors', () {
      expect(
        isNotificationSchedulingNotAuthorized(
          PlatformException(code: '500', message: 'Server error'),
        ),
        isFalse,
      );
    });
  });
}
