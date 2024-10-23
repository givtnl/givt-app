import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/network/network_info.dart';

part 'internet_connection_state.dart';

class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  InternetConnectionCubit(
    this._networkInfo,
  ) : super(InternetConnectionInitial()) {
    _init();
  }
  final NetworkInfo _networkInfo;
  StreamSubscription<bool>? hasInternetConnectionStream;

  void _init() {
    hasInternetConnectionStream =
        _networkInfo.hasInternetConnectionStream().listen(
      (hasConnection) {
        if (hasConnection) {
          emit(InternetConnectionLive());
        } else {
          emit(InternetConnectionLost());
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
