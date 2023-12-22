import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

mixin NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this.connectionChecker);

  final InternetConnection connectionChecker;

  @override
  Future<bool> get isConnected => connectionChecker.hasInternetAccess;
}
