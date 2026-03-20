part of 'for_you_goals_cubit.dart';

class ForYouGoalsState extends Equatable {
  const ForYouGoalsState({
    required this.summariesByCollectGroupId,
    required this.loadingIds,
    required this.failedIds,
    required this.isOffline,
  });

  factory ForYouGoalsState.initial({
    required bool isOffline,
  }) {
    return ForYouGoalsState(
      summariesByCollectGroupId: const {},
      loadingIds: const {},
      failedIds: const {},
      isOffline: isOffline,
    );
  }

  final Map<String, OrganisationGoalsSummary> summariesByCollectGroupId;
  final Set<String> loadingIds;
  final Set<String> failedIds;
  final bool isOffline;

  ForYouGoalsState copyWith({
    Map<String, OrganisationGoalsSummary>? summariesByCollectGroupId,
    Set<String>? loadingIds,
    Set<String>? failedIds,
    bool? isOffline,
  }) {
    return ForYouGoalsState(
      summariesByCollectGroupId:
          summariesByCollectGroupId ?? this.summariesByCollectGroupId,
      loadingIds: loadingIds ?? this.loadingIds,
      failedIds: failedIds ?? this.failedIds,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object> get props => [
    summariesByCollectGroupId,
    loadingIds,
    failedIds,
    isOffline,
  ];
}
