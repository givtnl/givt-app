import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

mixin NetworkInfo {
  bool get isConnected;

  Stream<bool> hasInternetConnectionStream();
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this.connectionChecker) {
    // First check if there is an internet connection
    connectionChecker.hasInternetAccess.then((value) {
      isConnected = value;
      _hasInternetConnectionStream.add(value);
    });

    // Listen for changes in the internet connection status
    connectionChecker.onStatusChange.listen((status) {
      isConnected = status == InternetStatus.connected;
      _hasInternetConnectionStream.add(isConnected);
    });
  }

  // bool hasInternetConnection
  final StreamController<bool> _hasInternetConnectionStream =
      StreamController<bool>.broadcast();

  @override
  bool isConnected = true;

  final InternetConnection connectionChecker;

  @override
  Stream<bool> hasInternetConnectionStream() =>
      _hasInternetConnectionStream.stream.distinct();
}
