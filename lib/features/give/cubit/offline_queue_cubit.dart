import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

part 'offline_queue_state.dart';

class OfflineQueueCubit extends Cubit<OfflineQueueState> {
  OfflineQueueCubit(
    this._givtRepository,
    this._networkInfo,
  ) : super(OfflineQueueState.initial(isOffline: !_networkInfo.isConnected)) {
    _wasOffline = !_networkInfo.isConnected;
    // [NetworkInfo.isConnected] defaults to true until the first real check.
    // false therefore means we already know the device is offline, so show
    // the banner without waiting for a stream event that may have been missed.
    if (!_networkInfo.isConnected) {
      _hasResolvedConnectivity = true;
    }
    _refreshFromCache(isOffline: !_networkInfo.isConnected);
    if (_networkInfo.isConnected && _hasPendingDonations()) {
      unawaited(_syncAndRefresh());
    }

    _queueSubscription = _givtRepository.offlineQueueChanged.listen((_) {
      _refreshFromCache(isOffline: !_networkInfo.isConnected);
    });

    _networkSubscription = _networkInfo.hasInternetConnectionStream().listen(
      (isConnected) {
        _hasResolvedConnectivity = true;

        if (!isConnected) {
          _wasOffline = true;
          _refreshFromCache(isOffline: true);
          return;
        }

        if (_wasOffline || _hasPendingDonations()) {
          unawaited(_syncAndRefresh());
        } else {
          _refreshFromCache(isOffline: false);
        }
        _wasOffline = false;
      },
    );
  }

  final GivtRepository _givtRepository;
  final NetworkInfo _networkInfo;

  late final StreamSubscription<void> _queueSubscription;
  late final StreamSubscription<bool> _networkSubscription;
  bool _wasOffline = false;
  bool _hasResolvedConnectivity = false;
  Timer? _syncRetryTimer;

  static const Duration _syncRetryDelay = Duration(seconds: 15);

  bool _hasPendingDonations() {
    return _givtRepository.getCachedOfflineGivtTransactions().isNotEmpty;
  }

  Future<void> _syncAndRefresh() async {
    try {
      await _givtRepository.syncOfflineGivts();
      _syncRetryTimer?.cancel();
      _syncRetryTimer = null;
    } catch (_) {
      if (_networkInfo.isConnected && _hasPendingDonations()) {
        _scheduleSyncRetry();
      }
    }
    _refreshFromCache(isOffline: !_networkInfo.isConnected);
  }

  void _scheduleSyncRetry() {
    if (_syncRetryTimer?.isActive ?? false) {
      return;
    }
    _syncRetryTimer = Timer(_syncRetryDelay, () {
      _syncRetryTimer = null;
      if (_networkInfo.isConnected && _hasPendingDonations()) {
        unawaited(_syncAndRefresh());
      }
    });
  }

  void _refreshFromCache({required bool isOffline}) {
    final transactions = _givtRepository.getCachedOfflineGivtTransactions();
    final totalAmount = transactions.fold<double>(
      0,
      (sum, transaction) => sum + transaction.amount,
    );

    emit(
      OfflineQueueState(
        isOffline: isOffline,
        pendingCount: transactions.length,
        totalAmount: totalAmount,
        hasResolvedConnectivity: _hasResolvedConnectivity,
      ),
    );
  }

  @override
  Future<void> close() {
    _syncRetryTimer?.cancel();
    _queueSubscription.cancel();
    _networkSubscription.cancel();
    return super.close();
  }
}
