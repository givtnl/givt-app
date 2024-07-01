import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

mixin NetworkInfo {
  bool get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this.connectionChecker) {
    // First check if there is an internet connection
    connectionChecker.hasInternetAccess.then((value) {
      isConnected = value;
    });

    // Listen for changes in the internet connection status
    connectionChecker.onStatusChange.listen((status) {
      isConnected = status == InternetStatus.connected;
    });
  }

  @override
  bool isConnected = true;

  final InternetConnection connectionChecker;
}
