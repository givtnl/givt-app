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
          emit(const FeaturedDoorToDoorState.hidden());
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

  Future<void> load() async {
    if (!_networkInfo.isConnected) {
      emit(const FeaturedDoorToDoorState.hidden());
      return;
    }

    try {
      final featured = await _fetchFeatured();
      if (featured == null || featured.nameSpace.trim().isEmpty) {
        emit(const FeaturedDoorToDoorState.hidden());
        return;
      }
      emit(FeaturedDoorToDoorState.loaded(featured));
    } on Exception {
      emit(const FeaturedDoorToDoorState.hidden());
    }
  }

  @override
  Future<void> close() async {
    await _internetSubscription.cancel();
    return super.close();
  }
}
