import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/give/utils/permission_request_guard.dart';

void main() {
  group('PermissionRequestGuard', () {
    setUp(PermissionRequestGuard.reset);
    tearDown(PermissionRequestGuard.reset);

    test('isConcurrentRequest matches the plugin mutex message', () {
      expect(
        PermissionRequestGuard.isConcurrentRequest(
          PlatformException(
            code: 'PermissionHandler.PermissionManager',
            message: PermissionRequestGuard.concurrentRequestMessage,
          ),
        ),
        isTrue,
      );
      expect(
        PermissionRequestGuard.isConcurrentRequest(
          PlatformException(code: 'other', message: 'unrelated'),
        ),
        isFalse,
      );
      expect(
        PermissionRequestGuard.isConcurrentRequest(Exception('nope')),
        isFalse,
      );
    });

    test('runs overlapping actions one at a time', () async {
      final order = <int>[];

      Future<int> delayed(int id) {
        return PermissionRequestGuard.run(() async {
          order.add(id);
          await Future<void>.delayed(const Duration(milliseconds: 20));
          order.add(id + 10);
          return id;
        });
      }

      final results = await Future.wait([delayed(1), delayed(2)]);

      expect(results, [1, 2]);
      expect(order, [1, 11, 2, 12]);
    });

    test('retries once after a concurrent PlatformException', () async {
      final warnings = <String>[];
      PermissionRequestGuard.warningLogger = warnings.add;

      var attempts = 0;
      final value = await PermissionRequestGuard.run(() async {
        attempts++;
        if (attempts == 1) {
          throw PlatformException(
            code: 'PermissionHandler.PermissionManager',
            message: PermissionRequestGuard.concurrentRequestMessage,
          );
        }
        return 7;
      });

      expect(value, 7);
      expect(attempts, 2);
      expect(warnings, isNotEmpty);
    });
  });
}
