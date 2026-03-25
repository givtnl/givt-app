import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/shared/models/organisation_goals.dart';
import 'package:givt_app/shared/repositories/organisation_goals_repository.dart';

part 'for_you_goals_state.dart';

class ForYouGoalsCubit extends Cubit<ForYouGoalsState> {
  ForYouGoalsCubit(
    this._organisationGoalsRepository,
    this._networkInfo,
  ) : super(ForYouGoalsState.initial(isOffline: !_networkInfo.isConnected)) {
    _internetSubscription = _networkInfo.hasInternetConnectionStream().listen(
      (isConnected) {
        if (!isConnected) {
          emit(
            state.copyWith(
              isOffline: true,
              loadingIds: const {},
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            isOffline: false,
          ),
        );
        if (_lastFavoriteIds.isNotEmpty) {
          unawaited(loadForFavorites(_lastFavoriteIds));
        }
      },
    );
  }

  final OrganisationGoalsRepository _organisationGoalsRepository;
  final NetworkInfo _networkInfo;
  late final StreamSubscription<bool> _internetSubscription;

  List<String> _lastFavoriteIds = const [];

  Future<void> loadForFavorites(List<String> favoriteIds) async {
    final deduplicatedFavoriteIds = favoriteIds.toSet().toList(growable: false);
    _lastFavoriteIds = deduplicatedFavoriteIds;

    if (deduplicatedFavoriteIds.isEmpty) {
      emit(
        state.copyWith(
          summariesByCollectGroupId: const {},
          loadingIds: const {},
          failedIds: const {},
        ),
      );
      return;
    }

    if (!_networkInfo.isConnected) {
      emit(
        state.copyWith(
          isOffline: true,
          loadingIds: const {},
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isOffline: false,
        loadingIds: deduplicatedFavoriteIds.toSet(),
        failedIds: Set<String>.from(state.failedIds)
          ..removeWhere(deduplicatedFavoriteIds.contains),
      ),
    );

    final nextSummaries = Map<String, OrganisationGoalsSummary>.from(
      state.summariesByCollectGroupId,
    );
    final failedIds = Set<String>.from(state.failedIds);

    await Future.wait(
      deduplicatedFavoriteIds.map((collectGroupId) async {
        try {
          final summary = await _organisationGoalsRepository.fetchGoalsSummary(
            collectGroupId,
          );
          nextSummaries[collectGroupId] = summary;
          failedIds.remove(collectGroupId);
        } on Exception {
          failedIds.add(collectGroupId);
        }
      }),
    );

    emit(
      state.copyWith(
        summariesByCollectGroupId: nextSummaries,
        loadingIds: const {},
        failedIds: failedIds,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _internetSubscription.cancel();
    return super.close();
  }
}
