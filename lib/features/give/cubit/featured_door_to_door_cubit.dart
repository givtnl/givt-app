import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/shared/models/featured_collect_group.dart';

part 'featured_door_to_door_state.dart';

class FeaturedDoorToDoorCubit extends Cubit<FeaturedDoorToDoorState> {
  FeaturedDoorToDoorCubit({
    required Future<FeaturedCollectGroup?> Function() fetchFeatured,
    required NetworkInfo networkInfo,
  }) : _fetchFeatured = fetchFeatured,
       _networkInfo = networkInfo,
       super(const FeaturedDoorToDoorState.hidden()) {
    _internetSubscription = _networkInfo.hasInternetConnectionStream().listen(
      (isConnected) {
        if (!isConnected) {
          _invalidateInFlightLoads();
          _emitIfOpen(const FeaturedDoorToDoorState.hidden());
          return;
        }
        unawaited(load());
      },
    );
    unawaited(load());
  }

  final Future<FeaturedCollectGroup?> Function() _fetchFeatured;
  final NetworkInfo _networkInfo;
  late final StreamSubscription<bool> _internetSubscription;
  int _loadGeneration = 0;

  Future<void> load() async {
    final generation = ++_loadGeneration;
    if (!_networkInfo.isConnected) {
      _emitIfCurrent(generation, const FeaturedDoorToDoorState.hidden());
      return;
    }

    try {
      final featured = await _fetchFeatured();
      if (!_isCurrent(generation)) {
        return;
      }
      if (!_networkInfo.isConnected ||
          featured == null ||
          featured.nameSpace.trim().isEmpty) {
        _emitIfCurrent(generation, const FeaturedDoorToDoorState.hidden());
        return;
      }
      _emitIfCurrent(generation, FeaturedDoorToDoorState.loaded(featured));
    } on Exception {
      _emitIfCurrent(generation, const FeaturedDoorToDoorState.hidden());
    }
  }

  void _invalidateInFlightLoads() {
    _loadGeneration++;
  }

  bool _isCurrent(int generation) => !isClosed && generation == _loadGeneration;

  void _emitIfCurrent(int generation, FeaturedDoorToDoorState next) {
    if (!_isCurrent(generation)) {
      return;
    }
    emit(next);
  }

  void _emitIfOpen(FeaturedDoorToDoorState next) {
    if (isClosed) {
      return;
    }
    emit(next);
  }

  @override
  Future<void> close() async {
    _invalidateInFlightLoads();
    await _internetSubscription.cancel();
    return super.close();
  }
}
