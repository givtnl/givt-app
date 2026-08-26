import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

mixin NetworkInfo {
  bool get isConnected;

  Stream<bool> hasInternetConnectionStream();
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this.connectionChecker) {
    // First check if there is an internet connection
    connectionChecker.hasInternetAccess.then(_setConnected);

    // Listen for changes in the internet connection status
    connectionChecker.onStatusChange.listen((status) {
      _setConnected(status == InternetStatus.connected);
    });
  }

  // bool hasInternetConnection
  final StreamController<bool> _hasInternetConnectionStream =
      StreamController<bool>.broadcast();

  bool _hasCompletedInitialCheck = false;

  @override
  bool isConnected = true;

  final InternetConnection connectionChecker;

  void _setConnected(bool connected) {
    isConnected = connected;
    _hasCompletedInitialCheck = true;
    _hasInternetConnectionStream.add(connected);
  }

  /// Replays the last known value to late subscribers.
  ///
  /// The underlying controller is broadcast without replay, so listeners
  /// created after the first check (for example the home offline banner) would
  /// otherwise miss the initial offline reading.
  @override
  Stream<bool> hasInternetConnectionStream() {
    return Stream<bool>.multi((controller) {
      if (_hasCompletedInitialCheck) {
        controller.add(isConnected);
      }
      final subscription = _hasInternetConnectionStream.stream.listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );
      controller
        ..onPause = subscription.pause
        ..onResume = subscription.resume
        ..onCancel = subscription.cancel;
    }).distinct();
  }
}
