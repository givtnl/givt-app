import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/give/cubit/offline_queue_cubit.dart';

void main() {
  group('OfflineQueueState.shouldShowBanner', () {
    test('is hidden when online with no pending donations', () {
      const state = OfflineQueueState(
        isOffline: false,
        pendingCount: 0,
        totalAmount: 0,
        hasResolvedConnectivity: true,
      );

      expect(state.shouldShowBanner, isFalse);
    });

    test('is visible when offline and connectivity is resolved', () {
      const state = OfflineQueueState(
        isOffline: true,
        pendingCount: 0,
        totalAmount: 0,
        hasResolvedConnectivity: true,
      );

      expect(state.shouldShowBanner, isTrue);
    });

    test('is hidden when offline before connectivity is resolved', () {
      const state = OfflineQueueState(
        isOffline: true,
        pendingCount: 0,
        totalAmount: 0,
        hasResolvedConnectivity: false,
      );

      expect(state.shouldShowBanner, isFalse);
    });

    test('is visible when donations are pending before connectivity resolves', () {
      const state = OfflineQueueState(
        isOffline: false,
        pendingCount: 2,
        totalAmount: 30,
        hasResolvedConnectivity: false,
      );

      expect(state.shouldShowBanner, isTrue);
    });
  });
}
