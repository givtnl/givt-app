part of 'organisation_bloc.dart';

enum OrganisationStatus {
  initial,
  loading,
  error,
  filtered,
}

class OrganisationState extends Equatable {
  const OrganisationState({
    this.organisations = const [],
    this.filteredOrganisations = const [],
    this.selectedType = -1,
    this.selectedCollectGroup = const CollectGroup.empty(),
    this.status = OrganisationStatus.initial,
    this.previousSearchQuery = '',
    this.favoritedOrganisations = const [],
    this.sortByFavorites = false,
    this.selectedAllocation,
    this.filterStartDate,
    this.filterEndDate,
    this.showOnlyNonAllocated = false,
  });

  final List<CollectGroup> organisations;
  final List<CollectGroup> filteredOrganisations;
  final int selectedType;
  final String previousSearchQuery;
  final CollectGroup selectedCollectGroup;
  final OrganisationStatus status;
  final List<String> favoritedOrganisations;
  final bool sortByFavorites;
  final String? selectedAllocation;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final bool showOnlyNonAllocated;

  OrganisationState copyWith({
    List<CollectGroup>? organisations,
    List<CollectGroup>? filteredOrganisations,
    int? selectedType,
    OrganisationStatus? status,
    CollectGroup? selectedCollectGroup,
    String? previousSearchQuery,
    List<String>? favoritedOrganisations,
    bool? sortByFavorites,
    String? selectedAllocation,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    bool? showOnlyNonAllocated,
  }) {
    return OrganisationState(
      organisations: organisations ?? this.organisations,
      filteredOrganisations:
          filteredOrganisations ?? this.filteredOrganisations,
      selectedType: selectedType ?? this.selectedType,
      status: status ?? this.status,
      selectedCollectGroup: selectedCollectGroup ?? this.selectedCollectGroup,
      previousSearchQuery: previousSearchQuery ?? this.previousSearchQuery,
      favoritedOrganisations:
          favoritedOrganisations ?? this.favoritedOrganisations,
      sortByFavorites: sortByFavorites ?? this.sortByFavorites,
      selectedAllocation: selectedAllocation ?? this.selectedAllocation,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
      showOnlyNonAllocated: showOnlyNonAllocated ?? this.showOnlyNonAllocated,
    );
  }

  @override
  List<Object?> get props => [
        organisations,
        selectedType,
        filteredOrganisations,
        status,
        selectedCollectGroup,
        previousSearchQuery,
        favoritedOrganisations,
        sortByFavorites,
        selectedAllocation,
        filterStartDate,
        filterEndDate,
        showOnlyNonAllocated,
      ];
}
