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
  });

  final List<CollectGroup> organisations;
  final List<CollectGroup> filteredOrganisations;
  final int selectedType;
  final String previousSearchQuery;
  final CollectGroup selectedCollectGroup;
  final OrganisationStatus status;
  final List<String> favoritedOrganisations;
  final bool sortByFavorites;

  OrganisationState copyWith({
    List<CollectGroup>? organisations,
    List<CollectGroup>? filteredOrganisations,
    int? selectedType,
    OrganisationStatus? status,
    CollectGroup? selectedCollectGroup,
    String? previousSearchQuery,
    List<String>? favoritedOrganisations,
    bool? sortByFavorites,
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
    );
  }

  @override
  List<Object> get props => [
        organisations,
        selectedType,
        filteredOrganisations,
        status,
        selectedCollectGroup,
        previousSearchQuery,
        favoritedOrganisations,
        sortByFavorites,
      ];
}
