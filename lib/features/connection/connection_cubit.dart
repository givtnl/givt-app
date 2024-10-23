import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/network/network_info.dart';

part 'connection_state.dart';

class ConnectionCubit extends Cubit<ConnectionState> {
  ConnectionCubit(
    this._networkInfo,
  ) : super(ConnectionInitial()) {
    _init();
  }
  final NetworkInfo _networkInfo;
  StreamSubscription<bool>? hasInternetConnectionStream;

  void _init() {
    hasInternetConnectionStream =
        _networkInfo.hasInternetConnectionStream().listen(
      (hasConnection) {
        if (hasConnection) {
          emit(ConnectionLive());
        } else {
          emit(ConnectionLost());
        }
      },
    );
  }

  @override
  Future<void> close() async {
    await hasInternetConnectionStream?.cancel();
    await super.close();
  }
}
