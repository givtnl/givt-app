import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/shared/models/featured_collect_group.dart';

part 'featured_door_to_door_state.dart';

class FeaturedDoorToDoorCubit extends Cubit<FeaturedDoorToDoorState> {
  FeaturedDoorToDoorCubit(
    this._apiService,
    this._networkInfo,
  ) : super(const FeaturedDoorToDoorState.hidden()) {
    // Single trigger. The stream replays the current connection status and
    // then emits changes, so an extra load() here would start a second request.
    _internetSubscription = _networkInfo.hasInternetConnectionStream().listen(
      (isConnected) {
        if (!isConnected) {
          // A response still in flight must not show the card after this.
          _generation++;
          if (!isClosed) {
            emit(const FeaturedDoorToDoorState.hidden());
          }
          return;
        }
        unawaited(load());
      },
    );
  }

  final APIService _apiService;
  final NetworkInfo _networkInfo;
  late final StreamSubscription<bool> _internetSubscription;

  /// Latest load. A fetch that finishes after a newer load, or after a
  /// disconnect, is ignored.
  int _generation = 0;

  Future<void> load() async {
    final generation = ++_generation;
    if (!_networkInfo.isConnected) {
      _emit(generation, const FeaturedDoorToDoorState.hidden());
      return;
    }

    try {
      final featured = await _apiService.getFeaturedDoorToDoorCollectGroup();
      if (!_networkInfo.isConnected ||
          featured == null ||
          featured.nameSpace.trim().isEmpty) {
        _emit(generation, const FeaturedDoorToDoorState.hidden());
        return;
      }
      _emit(generation, FeaturedDoorToDoorState.loaded(featured));
    } on Exception {
      _emit(generation, const FeaturedDoorToDoorState.hidden());
    }
  }

  void _emit(int generation, FeaturedDoorToDoorState next) {
    if (isClosed || generation != _generation) {
      return;
    }
    emit(next);
  }

  @override
  Future<void> close() async {
    _generation++;
    await _internetSubscription.cancel();
    return super.close();
  }
}
